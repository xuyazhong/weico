//
//  MyDetailCell.m
//  weico
//
//  Created by xyz on 15-3-1.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "MyDetailCell.h"

@implementation MyDetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"selected:%d",_selectid);
    }
    return self;
}

@end
