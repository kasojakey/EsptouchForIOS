//
//  IRViewController.h
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/3.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Telnet.h"

@interface IRViewController : UIViewController <TelnetDelegate>

@property (strong, nonatomic) IBOutlet UIButton *pairIRButton;

- (IBAction)powerButtonAction:(UIButton *)sender;

- (IBAction)addChannelButtonAction:(UIButton *)sender;
- (IBAction)subChannelButtonAction:(UIButton *)sender;

- (IBAction)addVoiceButtonAction:(UIButton *)sender;
- (IBAction)subVoiceButtonAction:(UIButton *)sender;

- (IBAction)pairIRButtonAction:(UIButton *)sender;

@end
