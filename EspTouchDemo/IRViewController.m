//
//  IRViewController.m
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/3.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import "IRViewController.h"
#import "Telnet.h"

@interface IRViewController ()
@property (nonatomic, strong) Telnet* telnet;
@property (nonatomic, strong) id<NSObject> observer;
@end

@implementation IRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.telnet = [Telnet sharedInstance];
    self.observer = [self.telnet registerDidReadData:^(NSNotification *notification) {
        NSDictionary *dict = notification.userInfo;
        LOGD(@"dict:%@", dict);
    }];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)powerButtonAction:(UIButton *)sender
{
    long val = 0x06F900FF;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
    [self.telnet sendWithString:json];
}

- (IBAction)addChannelButtonAction:(UIButton *)sender
{
    long val = 0x06F93AC5;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
    [self.telnet sendWithString:json];
}

- (IBAction)subChannelButtonAction:(UIButton *)sender
{
    long val = 0x06F928D7;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
    [self.telnet sendWithString:json];
}

- (IBAction)addVoiceButtonAction:(UIButton *)sender
{
    long val = 0x06F99867;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
    [self.telnet sendWithString:json];
}

- (IBAction)subVoiceButtonAction:(UIButton *)sender
{
    long val = 0x06F9A857;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
    [self.telnet sendWithString:json];
}

- (IBAction)pairIRButtonAction:(UIButton *)sender
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"getIR"];
    NSString* json = [self.telnet jsonDictionaryToJsonString:dict];
    [self.telnet sendWithString:json];
}

@end
