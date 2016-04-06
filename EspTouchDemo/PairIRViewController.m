//
//  PairIRViewController.m
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/6.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import "PairIRViewController.h"

@interface PairIRViewController ()
@property (nonatomic, strong) UIButton* currentButton;
@property (nonatomic, assign) BOOL getIRPairing;
@end

@implementation PairIRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 80, 60);
    //    button.backgroundColor = [UIColor blueColor];
    //    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[button setImage:[UIImage imageNamed:@"btng.png"] forState:UIControlStateNormal];
    [button setTitle:@"點擊" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

-(void)buttonAction:(UIButton *)sender
{
    //    LOGD(@"title:%@", sender.currentTitle);
    
    // 配對中
    if (self.getIRPairing == YES) {
        self.currentButton = sender;
    }
    else if ([sender.currentTitle isEqualToString:@"點擊"] == NO) {
//        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
//        [dictionary setObject:sender.currentTitle forKey:@"setIR"];
//        NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
//        [self.telnet sendWithString:json];
    }
}

@end
