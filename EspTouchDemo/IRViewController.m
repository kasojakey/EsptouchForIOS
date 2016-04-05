//
//  IRViewController.m
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/3.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import "IRViewController.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

#define HOST @"192.168.5.96"
#define PORT 9999

@interface IRViewController ()

@property (nonatomic, strong) GCDAsyncSocket* asyncSocket;

@end

@implementation IRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self connect];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:true];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Method

-(void)connect
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    NSString *host = HOST;
    uint16_t port = PORT;
    NSError *error = nil;
    if ([self.asyncSocket connectToHost:host onPort:port error:&error] == NO) {
        LOGD(@"Error connecting: %@", error);
    }
    else {
        [self.asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
    }
}

-(void)sendWithString:(NSString*)str
{
    NSData *requestData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.asyncSocket writeData:requestData withTimeout:-1 tag:0];
}

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

- (IBAction)powerButtonAction:(UIButton *)sender
{
    long val = 0x06F900FF;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self jsonDictionaryToJsonString:dictionary];
    [self sendWithString:json];
}

- (IBAction)addChannelButtonAction:(UIButton *)sender
{
    long val = 0x06F93AC5;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self jsonDictionaryToJsonString:dictionary];
    [self sendWithString:json];
}

- (IBAction)subChannelButtonAction:(UIButton *)sender
{
    long val = 0x06F928D7;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self jsonDictionaryToJsonString:dictionary];
    [self sendWithString:json];
}

- (IBAction)addVoiceButtonAction:(UIButton *)sender
{
    long val = 0x06F99867;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self jsonDictionaryToJsonString:dictionary];
    [self sendWithString:json];
}

- (IBAction)subVoiceButtonAction:(UIButton *)sender
{
    long val = 0x06F9A857;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self jsonDictionaryToJsonString:dictionary];
    [self sendWithString:json];
}

- (IBAction)pairIRButtonAction:(UIButton *)sender
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"getIR"];
    NSString* json = [self jsonDictionaryToJsonString:dict];
    [self sendWithString:json];
}

#pragma mark Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    LOGD(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    LOGD(@"socketDidSecure:%p", sock);
    
//    NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
//    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [sock writeData:requestData withTimeout:-1 tag:0];
//    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
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
        
        
        NSDictionary* dict = [self jsonDataToDictionary:data];
        // json
        if (dict != nil) {
            LOGD(@"Recv dict:%@", dict);
        }
        // 非json
        else {
            NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            LOGD(@"Recv Text:%@", response);
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

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    LOGD(@"didWritePartialDataOfLength");
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    LOGD(@"didReadPartialDataOfLength");
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    LOGD(@"didReceiveTrust");
}

@end
