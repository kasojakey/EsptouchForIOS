//
//  Telnet.h
//  EspTouchDemo
//
//  Created by jakeykaso on 2016/4/6.
//  Copyright © 2016年 白 桦. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Telnet;

@protocol TelnetDelegate <NSObject>
-(void)telnet:(Telnet*)telnet didReadData:(NSDictionary*)dictionary;
@end

@interface Telnet : NSObject

-(id)initWithDelegate:(id<TelnetDelegate>)delegate;

-(NSString*)jsonDictionaryToJsonString:(NSDictionary*)dictionary;
-(NSDictionary*)jsonDataToDictionary:(NSData*)data;

-(void)sendWithString:(NSString*)str;

@end
