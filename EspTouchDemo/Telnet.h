//
//  Telnet.h
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/6.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TelnetNotificationDidReadData @"TelnetNotificationDidReadData"

@class Telnet;

@interface Telnet : NSObject

+ (instancetype) sharedInstance;

-(BOOL)isConnected;
-(BOOL)connect;

-(void)sendWithString:(NSString*)str;

-(NSString*)jsonDictionaryToJsonString:(NSDictionary*)dictionary;
-(NSDictionary*)jsonDataToDictionary:(NSData*)data;

@end
