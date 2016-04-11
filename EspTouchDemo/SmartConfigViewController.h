//
//  ViewController.h
//  IRControl
//
//  Created by jakeykaso on 2016/4/3.
//  Copyright © 2016年 jakeykaso. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IP_User_defaults @"IP_User_defaults"

@interface SmartConfigViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *ssidLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UISwitch *isSsidHiddenSwitch;
@property (strong, nonatomic) IBOutlet UIButton *scanButton;

- (IBAction)scanButtonAction:(UIButton *)sender;

@end

