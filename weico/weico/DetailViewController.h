//
//  DetailViewController.h
//  weico
//
//  Created by xyz on 15-3-1.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetModel.h"

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) TweetModel *model;
@end
