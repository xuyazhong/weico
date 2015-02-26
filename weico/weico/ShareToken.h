//
//  ShareToken.h
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareToken : NSObject

@property (nonatomic,copy) NSString *token;
-(void)setToken:(NSString *)token;
-(NSString *)tk;
-(void)logout;
+(ShareToken *)sharedToken;
+(void)setUserInfo:(NSDictionary *)dict;
+(void)readUserInfo;
@end
