//
//  ShareToken.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "ShareToken.h"

@implementation ShareToken

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)setToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"write token%@",token);
    _token = token;
    NSArray *arr = [NSArray arrayWithObject:_token];
    [defaults setObject:arr forKey:@"tk"];
    [defaults synchronize];
}
-(NSString *)tk
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [defaults objectForKey:@"tk"];
    NSString *tk = [arr lastObject];
    _token = tk;
    NSLog(@"read token :%@",_token);
    if (_token)
    {
        return _token;
    }else
        return nil;
}
+(ShareToken *)sharedToken
{
    static ShareToken *token = nil;
    if (token == nil )
    {
        token = [[ShareToken alloc]init];
    }
    return token;
}
@end
