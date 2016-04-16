//
//  SpeechViewController.h
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/16.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeechViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)startRecord:(UIButton *)sender;
- (IBAction)stopRecord:(UIButton *)sender;

- (IBAction)MicPhoneDownAction:(UIButton *)sender;
- (IBAction)MicPhoneUpAction:(UIButton *)sender;

@end
