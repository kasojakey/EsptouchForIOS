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
@property (nonatomic, strong) UIButton* currentButton;
@property (nonatomic, assign) BOOL getIRPairing;

@end

@implementation IRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.telnet = [[Telnet alloc] initWithDelegate:self];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 80, 60);
//    button.backgroundColor = [UIColor blueColor];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[button setImage:[UIImage imageNamed:@"btng.png"] forState:UIControlStateNormal];
    [button setTitle:@"點擊" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
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

#pragma mark - Action

- (IBAction)powerButtonAction:(UIButton *)sender
{
    long val = 0x06F900FF;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithLong:val] forKey:@"setIR"];
    NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
    [self.telnet sendWithString:json];
}

-(void)buttonAction:(UIButton *)sender
{
//    LOGD(@"title:%@", sender.currentTitle);
    
    // 配對中
    if (self.getIRPairing == YES) {
        self.currentButton = sender;
    }
    else if ([sender.currentTitle isEqualToString:@"點擊"] == NO) {
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:sender.currentTitle forKey:@"setIR"];
        NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
        [self.telnet sendWithString:json];
    }
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

#pragma mark - TelnetDelegate

-(void)telnet:(Telnet*)telnet didReadData:(NSDictionary*)dictionary
{
    NSNumber* getIRNumber = [dictionary objectForKey:@"getIR"];
    NSNumber* getIRPairingNumber = [dictionary objectForKey:@"getIRPairing"];
    
    if (getIRNumber != nil) {
        long getIR = [getIRNumber longValue];
        LOGD(@"getIR:%ld", getIR);
        
        if (self.currentButton != nil) {
            if (getIR != -1 && getIR != 1) {
                [self.currentButton setTitle:[NSString stringWithFormat:@"%ld", getIR] forState:UIControlStateNormal];
            }
        }
    }
    else if (getIRPairingNumber != nil) {
        self.getIRPairing = [getIRPairingNumber boolValue];
        
        if (self.getIRPairing == YES) {
            self.view.backgroundColor = [UIColor yellowColor];
            self.pairIRButton.enabled = NO;
        }
        else {
            self.view.backgroundColor = [UIColor whiteColor];
            self.pairIRButton.enabled = YES;
        }
    }
}

@end
