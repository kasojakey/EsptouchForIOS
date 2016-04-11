//
//  ViewController.m
//  IRControl
//
//  Created by jakeykaso on 2016/4/3.
//  Copyright © 2016年 jakeykaso. All rights reserved.
//

#import "SmartConfigViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "ESPTouchTask.h"
#import "ESP_NetUtil.h"
#import "Telnet.h"

@interface SmartConfigViewController ()
    @property (atomic, strong) NSString* bssid;
    @property (atomic, strong) ESPTouchTask *espTouchTask;
@end

@implementation SmartConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.passwordTextField.delegate = self;
    
    NSDictionary *netInfo = [self fetchNetInfo];
    self.ssidLabel.text = [netInfo objectForKey:@"SSID"];
    self.bssid = [netInfo objectForKey:@"BSSID"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

// when user tap Enter or Return, disappear the keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)scanButtonAction:(UIButton *)sender
{
    ESPTouchResult* result = [self executeForResult];
    
    if (result.isSuc == YES) {
        NSString *ipAddrDataStr = [ESP_NetUtil descriptionInetAddrByData:result.ipAddrData];
        
        // 儲存
        [[NSUserDefaults standardUserDefaults] setObject:ipAddrDataStr forKey:IP_User_defaults];
        Telnet* telnet = [Telnet sharedInstance];
        if ([telnet isConnected] == NO) {
            [telnet connect];
        }
        else {
            [telnet reconnect];
        }
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:ipAddrDataStr delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Not Found" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Smart Config

- (ESPTouchResult *) executeForResult
{
    NSString *ssid = self.ssidLabel.text;
    NSString *password = self.passwordTextField.text;
    NSString *bssid = self.bssid;
    BOOL isSsidHidden = [self.isSsidHiddenSwitch isOn];
    self.espTouchTask = [[ESPTouchTask alloc] initWithApSsid:ssid andApBssid:bssid andApPwd:password andIsSsidHiden:isSsidHidden];
    
    ESPTouchResult * esptouchResult = [self.espTouchTask executeForResult];
    LOGD(@"ESPViewController executeForResult() result is: %@", esptouchResult);
    
    return esptouchResult;
}

#pragma mark - Network

- (NSString *)fetchSsid
{
    NSDictionary *ssidInfo = [self fetchNetInfo];

    return [ssidInfo objectForKey:@"SSID"];
}

- (NSString *)fetchBssid
{
    NSDictionary *bssidInfo = [self fetchNetInfo];

    return [bssidInfo objectForKey:@"BSSID"];
}

// refer to http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
//    LOGD(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
//        LOGD(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);

        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    
    return SSIDInfo;
}

@end
