//
//  Telnet.h
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/6.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TelnetNotification_DidReadData @"TelnetNotification_DidReadData"

@class Telnet;

@interface Telnet : NSObject

+ (instancetype) sharedInstance;

-(BOOL)isConnected;
-(BOOL)connect;

-(void)sendWithString:(NSString*)str;

-(id<NSObject>)registerDidReadData:(void (^)(NSNotification *notification))block;

-(NSString*)jsonDictionaryToJsonString:(NSDictionary*)dictionary;
-(NSDictionary*)jsonDataToDictionary:(NSData*)data;

@end
