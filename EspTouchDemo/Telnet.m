//
//  Telnet.m
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/6.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import "Telnet.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

#define HOST @"192.168.5.96"
#define PORT 9999

//#define Alive_Time 5.0f
#define Send_Time 1.0f

#define Now_Time [[NSDate date] timeIntervalSince1970]

@interface Telnet ()

@property (nonatomic, strong) GCDAsyncSocket* asyncSocket;

// 不使用
//@property (nonatomic, strong) NSTimer* aliveTimer;
//@property (nonatomic, assign) BOOL isAlive;

@property (nonatomic, assign) NSTimer* sendTimer;

@end

@implementation Telnet

+ (instancetype) sharedInstance
{
    static Telnet *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[Telnet alloc] init];
        
        if ([instance isConnected] == NO) {
            [instance connect];
        }
    });
    
    return instance;
}

-(id)init
{
    self = [super init];  // Call a designated initializer here.
    
    if (self != nil) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    }
    
    return self;
}

#pragma mark - Method

-(id<NSObject>)registerDidReadData:(void (^)(NSNotification *notification))block
{
    return [[NSNotificationCenter defaultCenter] addObserverForName:TelnetNotification_DidReadData object:self queue:[NSOperationQueue mainQueue] usingBlock:block];
}

-(BOOL)isConnected
{
    return [self.asyncSocket isConnected];
}

-(BOOL)connect
{
    NSString *host = HOST;
    uint16_t port = PORT;
    NSError *error = nil;
    if ([self.asyncSocket connectToHost:host onPort:port error:&error] == NO) {
        LOGD(@"Error connecting: %@", error);
        return NO;
    }
    else {
        [self.asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
        return YES;
    }
}

-(void)reconnect
{
    [self.asyncSocket disconnect];
    [self connect];
}

-(void)sendWithString:(NSString*)str
{
    if ([self.asyncSocket isConnected]) {
        NSData *requestData = [str dataUsingEncoding:NSUTF8StringEncoding];
        [self.asyncSocket writeData:requestData withTimeout:-1 tag:0];
        
        [self.sendTimer invalidate];
        self.sendTimer = nil;
        self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:Send_Time
                                                          target:self
                                                        selector:@selector(sendTimerAction:)
                                                        userInfo:requestData
                                                         repeats:NO];
    }
}

//-(void)sendAlive
//{
//    [self sendWithString:@"Alive"];
//
//    // 是活動的
//    if (self.isAlive == YES) {
//        self.isAlive = NO;
//    }
//    // 沒有活動
//    else {
//        [self reconnect];
//    }
//}

-(NSString*)jsonDictionaryToJsonString:(NSDictionary*)dictionary
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        LOGD(@"getJsonString:%@", error);
        return nil;
    }
    else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

-(NSDictionary*)jsonDataToDictionary:(NSData*)data
{
    NSError *error = nil;
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        //        LOGD(@"getJsonDictionary:%@", error);
        return nil;
    }
    else {
        return dictionary;
    }
}

#pragma mark - Action

//-(void)sendAliveTimerAction:(id)userinfo
//{
//    [self sendAlive];
//}

-(void)sendTimerAction:(id)userinfo
{
    LOGD(@"發生錯誤");
    [self reconnect];
}

#pragma mark Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    LOGD(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
    self.sendTimer = nil;
    
    //    self.isAlive = YES;
    //    [self.aliveTimer invalidate];
    //    self.aliveTimer = nil;
    //    self.aliveTimer = [NSTimer scheduledTimerWithTimeInterval:Alive_Time
    //                                                           target:self
    //                                                         selector:@selector(sendAliveTimerAction:)
    //                                                         userInfo:nil
    //                                                          repeats:YES];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    LOGD(@"socketDidSecure:%p", sock);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //    LOGD(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //    LOGD(@"socket:%p didReadData:withTag:%ld", sock, tag);
    
    //    LOGD("data:%@", data);
    if ([data isEqualToData:[GCDAsyncSocket CRLFData]] == NO) {
        //        LOGD(@"data:%@", data);
        
        // 清除sendTimer
        [self.sendTimer invalidate];
        self.sendTimer = nil;
        
        NSDictionary* dict = [self jsonDataToDictionary:data];
        // json
        if (dict != nil) {
//            LOGD(@"Recv dict:%@", dict);
//            [self.delegate telnet:self didReadData:dict];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TelnetNotification_DidReadData object:self userInfo:dict];
        }
        // 非json
        else {
            NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
//            if ([response hasPrefix:@"Alive"]) {
//                self.isAlive = YES;
//            }
//            else {
            LOGD(@"Recv Text:%@", response);
//            }
        }
    }
    
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    LOGD(@"socketDidDisconnect:%p withError: %@", sock, err);
    
    [self connect];
}

//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
//                 elapsed:(NSTimeInterval)elapsed
//               bytesDone:(NSUInteger)length
//{
//    LOGD(@"shouldTimeoutWriteWithTag");
//}

//- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
//{
//    LOGD(@"didWritePartialDataOfLength");
//}
//
//- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
//{
//    LOGD(@"didReadPartialDataOfLength");
//}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    LOGD(@"didReceiveTrust");
}

@end
