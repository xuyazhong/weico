//
//  TweetModel.h
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface TweetModel : NSObject


@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *tid;
@property (nonatomic,copy) NSString *mid;
@property (nonatomic,copy) NSString *idstr;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSArray *pic_urls;
@property (nonatomic,copy) NSString *thumbnail_pic;
@property (nonatomic,copy) NSString *rid;
@property (nonatomic,strong) UserModel *user;
@property (nonatomic,strong) TweetModel *model;

//储存微博正文的size
@property (nonatomic,assign) CGSize size;
//计算微博正文的size的方法
-(CGSize)currentSize;

@end
