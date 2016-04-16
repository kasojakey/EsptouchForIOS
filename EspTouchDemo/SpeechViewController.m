//
//  SpeechViewController.m
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/16.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import "SpeechViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PairViewController.h"
#import "Telnet.h"

//#define GOOGLE_API_KEY @"AIzaSyAcalCzUvPmmJ7CZBFOEWx2Z1ZSn4Vs1gg"
#define GOOGLE_API_KEY @"AIzaSyCbLbG7mdfiGMuv41P3CVk1chHBuKebj4U"

@interface SpeechViewController ()
@property (nonatomic, strong) AVAudioRecorder* audioRecorder;
@property (nonatomic, strong) NSURL *audioUrl;

@property (nonatomic, strong) Telnet* telnet;
@property (nonatomic, strong) NSArray* IRPojoList;
@end

@implementation SpeechViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMax],     AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 1],                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:16000],               AVSampleRateKey,
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    nil];
    
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    self.audioUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/record.caf", NSTemporaryDirectory()]];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.audioUrl settings:recordSettings error:&error];
    
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        if ([self.audioRecorder prepareToRecord]) {
            NSLog(@"Prepare successful");
        }
    }
    
    self.telnet = [Telnet sharedInstance];
    self.IRPojoList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:IR_User_defaults]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)startRecord:(UIButton *)sender
{
    [self.audioRecorder record];
}

- (IBAction)stopRecord:(UIButton *)sender
{
    [self.audioRecorder stop];
    
    NSString *urlString = [NSString stringWithFormat:@"https://www.google.com/speech-api/v2/recognize?xjerr=1&lang=zh-TW&key=%@", GOOGLE_API_KEY]; // GOOGLE_API_KEY: is obtained from google API Access
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSError* error;
    NSData* byteData = [NSData dataWithContentsOfURL:self.audioUrl options:NSDataReadingUncached error:&error];
    
    if (error != nil) {
        LOGD(@"無法開啟檔案%@", self.audioUrl);
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:byteData];
    [request addValue:@"audio/l16; rate=16000" forHTTPHeaderField:@"Content-Type"];
    [request setURL:url];
    [request setTimeoutInterval:15];
    
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]; // the data with trancribed result
    
//    LOGD(@"data:%@", data);
    NSString* json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    LOGD(@"json:%@", json);
    
//    NSString* json = @"{\"result\":[]}{\"result\":[{\"alternative\":[{\"transcript\":\"開電視\",\"confidence\":0.87302941},{\"transcript\":\"開店是\"},{\"transcript\":\"開店市\"},{\"transcript\":\"開店事\"},{\"transcript\":\"開店式\"}],\"final\":true}],\"result_index\":0}";
    
    NSRange range1 = [json rangeOfString:@"[{\"transcript\":\""];
    if (range1.location == NSNotFound) {
        LOGD(@"對應不到");
        return;
    }
    
    json = [json substringFromIndex:range1.length + range1.location];
//    LOGD(@"json:%@", json);
    
    NSRange range2 = [json rangeOfString:@"\""];
    json = [json substringToIndex:range2.location];
    LOGD(@"json:%@", json);
    self.resultLabel.text = json;
    
    // 必須清除，否則無法再錄音
    [self.audioRecorder deleteRecording];
    
    for (NSDictionary* dict in self.IRPojoList) {
        NSString* name = [dict objectForKey:@"name"];
        if ([name isEqualToString:json] == YES) {
            LOGD(@"配到了");
            
            NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:[dict objectForKey:@"IR"] forKey:@"setIR"];
            NSString* json = [self.telnet jsonDictionaryToJsonString:dictionary];
            [self.telnet sendWithString:json];
            break;
        }
    }
}

@end
