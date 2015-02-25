//
//  AppDelegate.h
//  weico
//
//  Created by xuyazhong on 15/2/22.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendMessageToWeiboViewController;

@interface AppDelegate : UIResponder<UIApplicationDelegate, WeiboSDKDelegate>
{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SendMessageToWeiboViewController *viewController;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@end
