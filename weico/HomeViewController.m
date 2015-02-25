//
//  HomeViewController.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"
#import "ShareToken.h"
#import "TweetModel.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ListsModel.h"
#import "UpdateTweetVC.h"


@interface HomeViewController ()
{
    UITableView *_myTableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_groupListArray;
    int currentPage;
    NSString *currentGroupId;
    NSString *currentUrl;
    UIScrollView *groupList;
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    UIButton *titleBtn;
    ShareToken *mytoken;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        mytoken = [ShareToken sharedToken];
    }
    return self;
}

- (void)viewDidLoad
{
    currentPage = 1;
    _dataArray = [[NSMutableArray alloc]init];
    _groupListArray = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    self.title = @"首页";
    currentUrl = kURLHomeLine;
    [self createNav];
    [self createUI];
    [self getJSON:currentPage andUrl:currentUrl andGroupID:currentGroupId];
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    header = [[MJRefreshHeaderView alloc]initWithScrollView:_myTableView];
    footer = [[MJRefreshFooterView alloc]initWithScrollView:_myTableView];
    header.delegate = self;
    footer.delegate = self;
}
-(void)createNav
{
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    updateBtn.frame = CGRectMake(0, 0, 40, 40);
    [updateBtn setBackgroundImage:[UIImage imageNamed:@"mask_timeline_top_icon_2"] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateTweet) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:updateBtn];
    self.navigationItem.rightBarButtonItem = right;
    titleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [titleBtn setFrame:CGRectMake(0, 0, 80, 64)];
    [titleBtn setTitle:@"首页" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(listGroup:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
//    self.navigationController.navigationItem.titleView = titleBtn;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:        mytoken.token,@"access_token", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kURLGroupLists parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        groupList = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, 64, 200, 300)];
        groupList.backgroundColor = [UIColor blackColor];
        groupList.alpha = 0.8;
        groupList.hidden = YES;
        NSArray *array = [responseObject objectForKey:@"lists"];
        int i=0;
        for (NSDictionary *subDict  in array)
        {
            ListsModel *model = [[ListsModel alloc]init];
            model.name = [subDict objectForKey:@"name"];
            model.idstr = [subDict objectForKey:@"idstr"];
            //NSLog(@"%@",[subDict objectForKey:@"name"]);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setFrame:CGRectMake(5, 5+30*i, 190, 40)];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.tag = 50 + i;
            [btn addTarget:self action:@selector(selectGroup:) forControlEvents:UIControlEventTouchUpInside];

            [btn setTitle:[subDict objectForKey:@"name"] forState:UIControlStateNormal];
            [groupList addSubview:btn];
            [groupList setContentSize:CGSizeMake(0, 5+30*i+30)];
            [_groupListArray addObject:model];
            i++;
        }
        [self.view addSubview:groupList];

        //NSLog(@"group list success:%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"group list error:%@",error.localizedDescription);
    }];
}
-(void)updateTweet
{
    UpdateTweetVC *update = [[UpdateTweetVC alloc]init];
    UINavigationController *upNav = [[UINavigationController alloc]initWithRootViewController:update];
    [self presentViewController:upNav animated:YES completion:nil];
}
-(void)listGroup:(UIButton *)btn
{
    if (btn.selected == YES)
    {
        NSLog(@"select");
        btn.selected = NO;
        groupList.hidden = YES;
        //[self.view bringSubviewToFront:groupList];
    }else
    {
        NSLog(@"normal");
        btn.selected = YES;
        groupList.hidden = NO;
        [self.view bringSubviewToFront:groupList];
    }
}
-(void)selectGroup:(UIButton *)btn
{
    ListsModel *model = [_groupListArray objectAtIndex:btn.tag-50];
    NSLog(@"name:%@",model.name);
    NSLog(@"id:%@",model.idstr);
    //btn.titleLabel.text
    [titleBtn setTitle:model.name forState:UIControlStateNormal];
    //self.navigationItem.titleView = btn;
    for (int i=0; i<_dataArray.count; i++)
    {
        UIButton *myBtn = (UIButton *)[self.view viewWithTag:50+i];
        myBtn.selected = NO;
    }
    btn.selected = YES;
    titleBtn.selected = NO;
    groupList.hidden = YES;
    currentGroupId = model.idstr;
    currentPage=1;
    currentUrl = kURLGroup;
    [self getJSON:currentPage andUrl:currentUrl andGroupID:currentGroupId];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    groupList.hidden = YES;
}
-(void)getJSON:(int)page andUrl:(NSString *)url andGroupID:(NSString *)groupid
{
    NSDictionary *dict;
    if (groupid != nil)
    {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:mytoken.token,@"access_token",groupid,@"list_id",[NSString stringWithFormat:@"%d",page],@"page", nil];

    }else
    {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:mytoken.token,@"access_token",[NSString stringWithFormat:@"%d",page],@"page", nil];
    }
    NSLog(@"dict:%@",dict);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (page == 1)
        {
            [_dataArray removeAllObjects];
        }
        NSLog(@"wbtoken:%@",mytoken.token);
        NSArray *array = [responseObject objectForKey:@"statuses"];
        for (NSDictionary *subDict in array)
        {
            TweetModel *model = [[TweetModel alloc]init];
            /*
             计算时间
             */
            //设置时间
            NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
            iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
            
            //必须设置，否则无法解析
            iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            NSDate *date=[iosDateFormater dateFromString:[subDict objectForKey:@"created_at"]];
            
            //目的格式
            NSDateFormatter *resultFormatter=[[NSDateFormatter alloc]init];
            [resultFormatter setDateFormat:@"MM月dd日 HH:mm"];
            
            model.created_at = [resultFormatter stringFromDate:date];
            
            //model.created_at = [subDict objectForKey:@"created_at"];
            model.tid = [subDict objectForKey:@"id"];
            model.mid = [subDict objectForKey:@"mid"];
            model.idstr = [subDict objectForKey:@"idstr"];
            model.text = [subDict objectForKey:@"text"];
            //model.source = [subDict objectForKey:@"source"];
            model.source = [self flattenHTML:[subDict objectForKey:@"source"]];
            model.rid = [subDict objectForKey:@"rid"];
            NSArray *picArr = [subDict objectForKey:@"pic_urls"];
            NSMutableArray *picUrlArray = [[NSMutableArray alloc]init];
            for (NSDictionary *picDict in picArr)
            {
                [picUrlArray addObject:[picDict objectForKey:@"thumbnail_pic"]];
            }
            model.pic_urls = picUrlArray;
            //model.thumbnail_pic = [subDict objectForKey:@"thumbnail_pic"];
            NSDictionary *userDict = [subDict objectForKey:@"user"];
            UserModel *user = [[UserModel alloc]init];
            user.name = [userDict objectForKey:@"name"];
            user.uid = [userDict objectForKey:@"id"];
            user.profile_image_url = [userDict objectForKey:@"profile_image_url"];
            model.user = user;
            //计算好字符串的size,将值提前存到数据模型中
            model.size = [model currentSize];
            [_dataArray addObject:model];
        }
        NSLog(@"dataArray:%@",_dataArray);
        //NSLog(@"success:%@",responseObject);
        
        [_myTableView reloadData];
        [header endRefreshing];
        [footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error:%@",error.localizedDescription);
    }];
    
}

-(NSString *)flattenHTML:(NSString *)html
{
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO)
    {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    } // while //
    
    return html;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"custom";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[TweetCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    TweetModel *model = [_dataArray objectAtIndex:indexPath.row];
    //cell.textLabel.text = model.text;
    [cell.userInfo setImageWithURL:[NSURL URLWithString:model.user.profile_image_url]];
    //cell.tweetLabel.text = model.text;
    
    cell.tweetLabel.text = model.text;
    cell.tweetLabel.font = [UIFont systemFontOfSize:16];
    cell.tweetLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.tweetLabel.numberOfLines = 0;
    cell.tweetLabel.frame = CGRectMake(10, 70, model.size.width, model.size.height);
    
    cell.nickName.text = model.user.name;
    cell.timeLabel.text = model.created_at;
    cell.timeLabel.font = [UIFont systemFontOfSize:12];
    cell.sourceLabel.text = [NSString stringWithFormat:@"来自%@",model.source];
    cell.sourceLabel.font = [UIFont systemFontOfSize:12];
    if (model.pic_urls.count>0)
    {
        cell.tweetImage.hidden = NO;
        [cell.tweetImage setImageWithURL:[NSURL URLWithString:[model.pic_urls firstObject]]];
        NSLog(@"pic:%@",[model.pic_urls firstObject]);
        cell.tweetImage.frame = CGRectMake(10, 55+model.size.height+10+10, 80, 80);
        
        [cell.controlview setFrame:CGRectMake(10, 55+model.size.height+10+90, 300, 40)];
    }else
    {
        cell.tweetImage.hidden = YES;
        [cell.controlview setFrame:CGRectMake(10, 55+model.size.height+10+5, 300, 40)];
    }
    //cell.timeLabel.text =
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetModel *model = [_dataArray objectAtIndex:indexPath.row];
    NSInteger count = model.pic_urls.count;
    if (count >0)
    {
        int customHeight = 55+model.size.height+10+80+40;
//        switch (count)
//        {
//            case 1:
//            case 2:
//            case 3:
//                customHeight = 55+model.size.height+10+80+100;
//                break;
//            case 4:
//            case 5:
//            case 6:
//                customHeight =  55+model.size.height+10+160+100;
//                break;
//            case 7:
//            case 8:
//            case 9:
//                customHeight =  55+model.size.height+10+240+10+100;
//                break;
//            default:
//                break;
//        }
        return customHeight;
    }else
    {
        return 55+model.size.height+10+40;
    }
}



#pragma mark - MJRefreshBaseViewDelegate
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[header class]])
    {
        NSLog(@"下拉刷新");
        currentPage = 1;
    }else if([refreshView isKindOfClass:[footer class]])
    {
        NSLog(@"上拉加载");
        currentPage ++;
    }
    [self getJSON:currentPage andUrl:currentUrl andGroupID:currentGroupId];
}
// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    
}
// 刷新状态变更就会调用
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    
}
@end
