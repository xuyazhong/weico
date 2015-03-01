//
//  DetailViewController.m
//  weico
//
//  Created by xyz on 15-3-1.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "DetailViewController.h"
#import "DeviceManager.h"
#import "TweetCell.h"




@interface DetailViewController ()
{
    NSMutableArray *_dataArray;
    NSMutableArray *currentArray;
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    NSMutableArray *tableviewArray;
    UILabel *selectedLabel;
    UIScrollView *myscrollview;
}
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _data1 = [[NSMutableArray alloc]init];
    _data2 = [[NSMutableArray alloc]init];
    _data3 = [[NSMutableArray alloc]initWithObjects:_model, nil];
    currentArray = [[NSMutableArray alloc]init];
    tableviewArray = [[NSMutableArray alloc]init];
    [_dataArray addObject:_data1];
    [_dataArray addObject:_data2];
    [_dataArray addObject:_data3];
    
    myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,40,[DeviceManager currentScreenSize].width, [DeviceManager currentScreenSize].height-80)];
    myscrollview.contentSize = CGSizeMake(320*3, 0);
    myscrollview.contentOffset = CGPointMake(320, 0);
    myscrollview.pagingEnabled = YES;
    UITableView *mytableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [DeviceManager currentScreenSize].width, [DeviceManager currentScreenSize].height-80)];
    mytableview1.delegate = self;
    mytableview1.dataSource = self;
    UITableView *mytableview2 = [[UITableView alloc]initWithFrame:CGRectMake(320, 0, [DeviceManager currentScreenSize].width, [DeviceManager currentScreenSize].height-80)];
    mytableview2.delegate = self;
    mytableview2.dataSource = self;
    UITableView *mytableview3 = [[UITableView alloc]initWithFrame:CGRectMake(640, 0, [DeviceManager currentScreenSize].width, [DeviceManager currentScreenSize].height-80)];
    mytableview3.delegate = self;
    mytableview3.dataSource = self;
    [myscrollview addSubview:mytableview1];
    [myscrollview addSubview:mytableview2];
    [myscrollview addSubview:mytableview3];
    [tableviewArray addObject:mytableview1];
    [tableviewArray addObject:mytableview2];
    [tableviewArray addObject:mytableview3];
    [self.view addSubview:myscrollview];
    
    [self addHeaderWithFrame:CGRectMake(0,64 , [DeviceManager currentScreenSize].width, 40)];
    [self addFooterWithFrame:CGRectMake(0, [DeviceManager currentScreenSize].height-40,[DeviceManager currentScreenSize].width, 40)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)addHeaderWithFrame:(CGRect)frame
{
    UIView *headerView = [[UIView alloc]initWithFrame:frame];
    //headerView.backgroundColor = [UIColor greenColor];
    CGFloat btnWidth = (frame.size.width-20)/3;
    //NSLog(@"btnwidth:%f",btnWidth);
    UILabel *repostCount = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 40, 13)];
    repostCount.text = [NSString stringWithFormat:@"%@",_model.reposts_count];
    repostCount.textAlignment = NSTextAlignmentCenter;
    repostCount.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:repostCount];
    UIButton *repostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [repostBtn setTitle:@"转发" forState:UIControlStateNormal];
    [repostBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [repostBtn setFrame:CGRectMake(10, 16, 40, 13)];
    [repostBtn addTarget:self action:@selector(switchList:) forControlEvents:UIControlEventTouchUpInside];
    repostBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    repostBtn.tag = 101;
    [headerView addSubview:repostBtn];
    
    UILabel *commentCount = [[UILabel alloc]initWithFrame:CGRectMake(10+btnWidth, 3, 40, 13)];
    commentCount.text = [NSString stringWithFormat:@"%@",_model.comments_count];
    commentCount.textAlignment = NSTextAlignmentCenter;
    commentCount.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:commentCount];
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [commentBtn setFrame:CGRectMake(10+btnWidth, 16, 40, 13)];
    [commentBtn addTarget:self action:@selector(switchList:) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];;
    commentBtn.tag = 102;
    [headerView addSubview:commentBtn];
    
    selectedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+btnWidth, 37, 40, 3)];
    selectedLabel.backgroundColor = [UIColor orangeColor];
    
    [headerView addSubview:selectedLabel];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10+btnWidth+btnWidth, 3, 40, 13)];
    label.text = @"查看";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label];
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setTitle:@"微博" forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [detailBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [detailBtn setFrame:CGRectMake(10+btnWidth+btnWidth, 16, 40, 13)];
    [detailBtn addTarget:self action:@selector(switchList:) forControlEvents:UIControlEventTouchUpInside];
    detailBtn.tag = 103;
    [headerView addSubview:detailBtn];
    [self.view addSubview:headerView];
    
}
-(void)switchList:(UIButton *)btn
{
    CGRect frame = selectedLabel.frame;
    frame.origin.x = btn.frame.origin.x;
    selectedLabel.frame = frame;
    CGPoint point ;
    //[currentArray setArray:[_dataArray objectAtIndex:btn.tag-101]];
    if (frame.origin.x/100>2)
    {
        point = CGPointMake(640, 0);
    }else if(frame.origin.x/100>1)
    {
        point = CGPointMake(320, 0);
    }else
    {
        point = CGPointMake(0, 0);
    }
    myscrollview.contentOffset = point;
    
}
-(void)addLabelWithFrameX:(CGFloat)x toView:(UIView *)view
{
    CGRect frame = CGRectMake(x, 5, 2, 20);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = [UIColor orangeColor];
    [view addSubview:label];
}
-(void)addFooterWithFrame:(CGRect)frame
{
    
    UIView *footerView = [[UIView alloc]initWithFrame:frame];
    //footerView.backgroundColor = [UIColor yellowColor];
    CGFloat btnWidth = 60;
    
    UIButton *repostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [repostBtn setTitle:@"转发" forState:UIControlStateNormal];
    [repostBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [repostBtn setFrame:CGRectMake(10, 5, btnWidth, 20)];
    [repostBtn addTarget:self action:@selector(repostAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:repostBtn];
    
    [self addLabelWithFrameX:70 toView:footerView];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [commentBtn setFrame:CGRectMake(10+btnWidth+2, 5, btnWidth, 20)];
    [footerView addSubview:commentBtn];
    [self addLabelWithFrameX:132 toView:footerView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(10+btnWidth+btnWidth+4, 5, btnWidth, 20)];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:cancelBtn];
    [self.view addSubview:footerView];
}
-(void)repostAction
{
    
}
-(void)commentAction
{
    
}
-(void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}
@end
