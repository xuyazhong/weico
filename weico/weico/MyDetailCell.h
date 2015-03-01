//
//  MyDetailCell.h
//  weico
//
//  Created by xyz on 15-3-1.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDetailCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITableView *MyDetailTableView;
@property (nonatomic,assign) NSInteger selectid;

@end
