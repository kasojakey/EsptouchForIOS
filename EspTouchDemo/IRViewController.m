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
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    NSString *host = HOST;
    uint16_t port = PORT;
    NSError *error = nil;
    if ([self.asyncSocket connectToHost:host onPort:port error:&error] == NO) {
        LOGD(@"Error connecting: %@", error);
    }
}

- (void)viewWillAppear:(BOOL)animated
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

-(void)sendWithString:(NSString*)str
{
    NSData *requestData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.asyncSocket writeData:requestData withTimeout:-1 tag:0];
    [self.asyncSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (IBAction)powerButtonAction:(UIButton *)sender
{
    [self sendWithString:@"p"];
}

- (IBAction)addChannelButtonAction:(UIButton *)sender
{
    [self sendWithString:@"w"];
}

- (IBAction)subChannelButtonAction:(UIButton *)sender
{
    [self sendWithString:@"s"];
}

- (IBAction)addVoiceButtonAction:(UIButton *)sender
{
    [self sendWithString:@"d"];
}

- (IBAction)subVoiceButtonAction:(UIButton *)sender
{
    [self sendWithString:@"a"];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    LOGD(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    LOGD(@"socketDidSecure:%p", sock);
    
    NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [sock writeData:requestData withTimeout:-1 tag:0];
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    LOGD(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    LOGD(@"socket:%p didReadData:withTag:%ld", sock, tag);
    
    NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    LOGD(@"HTTP Response:\n%@", httpResponse);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    LOGD(@"socketDidDisconnect:%p withError: %@", sock, err);
}

@end
