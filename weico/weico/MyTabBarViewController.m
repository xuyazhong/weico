//
//  MyTabBarViewController.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "HomeViewController.h"
#import "AtMeViewController.h"
#import "CommentMeViewController.h"
#import "FavListViewController.h"
#import "MeViewController.h"
#import "DeviceManager.h"
#import "NetManager.h"
#import "ShareToken.h"
#import "AFNetworking.h"
#import "UIButton+AFNetworking.h"


@interface MyTabBarViewController ()
{
    NSString *currentHeadImage;
}
@end

@implementation MyTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getJSON];
    
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)getJSON
{
    
    NSDictionary *info = [ShareToken readUserInfo];
    NSString *uid = [info objectForKey:@"uid"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[ShareToken readToken],@"access_token",uid,@"uid", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kURLShowMe parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"success:%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            currentHeadImage = [responseObject objectForKey:@"profile_image_url"];
        }
        NSLog(@"head:%@",currentHeadImage);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failed:%@",error.localizedDescription);
    }];
}
-(void)createUI
{
    
    
    FavListViewController *view1 = [[FavListViewController alloc]init];
    UINavigationController *nvc1 = [[UINavigationController alloc]initWithRootViewController:view1];
    
    CommentMeViewController *view2 = [[CommentMeViewController alloc]init];
    UINavigationController *nvc2 = [[UINavigationController alloc]initWithRootViewController:view2];
    
    HomeViewController *view3 = [[HomeViewController alloc]init];
    UINavigationController *nvc3 = [[UINavigationController alloc]initWithRootViewController:view3];
    
    AtMeViewController *view4 = [[AtMeViewController alloc]init];
    UINavigationController *nvc4 = [[UINavigationController alloc]initWithRootViewController:view4];
    
    MeViewController *view5 = [[MeViewController alloc]init];
    UINavigationController *nvc5 = [[UINavigationController alloc]initWithRootViewController:view5];
    

    
    NSArray *array = [NSArray arrayWithObjects:nvc1,nvc2,nvc3,nvc4,nvc5, nil];
    self.viewControllers = array;
    
    
    [self customTabBar];
}
-(void)customTabBar
{
    self.tabBar.hidden = YES;
    CGFloat tabBarViewY = self.view.frame.size.height - 49 ;
    
    UIImageView  *customTabBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabBarViewY, self.view.bounds.size.width, 49)];
    customTabBar.userInteractionEnabled = YES;
    customTabBar.image = [UIImage imageNamed:@"myTabBar"];
    //customTabBar.tintColor = [UIColor whiteColor];
    
//    NSArray *norArr = [NSArray arrayWithObjects:@"home_tab_icon_1",@"home_tab_icon_2",@"home_tab_icon_3",@"home_tab_icon_4", nil];
//    
//    NSArray *selArr = [NSArray arrayWithObjects:@"home_tab_icon_1_selected",@"home_tab_icon_2_selected",@"home_tab_icon_3_selected",@"home_tab_icon_4_selected", nil];
    
    NSArray *norArr = [NSArray arrayWithObjects:@"tab_favlist_selected",@"tab_user_comments_selected",@"tab_user_home_groups_selected",@"tab_user_at_selected",@"tab_user_home_special_selected", nil];
    
    //NSArray *selArr = [NSArray arrayWithObjects:@"home_tab_icon_1_selected",@"home_tab_icon_2_selected",@"home_tab_icon_3_selected",@"home_tab_icon_4_selected", nil];
    CGFloat btnWidth = [DeviceManager currentScreenSize].width/norArr.count;
    for (int i=0; i<norArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(10+btnWidth*i, 0, 45, 45);
        btn.tintColor = [UIColor orangeColor];
        //btn.tintColor = [UIColor clearColor];
        if (i==4)
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"corner_circle"] forState:UIControlStateNormal];
            //[btn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:currentHeadImage]];
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:currentHeadImage]];
            
            [btn setImageForState:UIControlStateNormal withURLRequest:request placeholderImage:[UIImage imageNamed:@"tab_user_home_special_selected"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                NSLog(@"success");
            } failure:^(NSError *error)
            {
                NSLog(@"failed:%@",error.localizedDescription);
            }];
        }else
        [btn setImage:[UIImage imageNamed:norArr[i]] forState:UIControlStateNormal];
        
        //[btn setImage:[UIImage imageNamed:selArr[i]] forState:UIControlStateSelected];
        btn.tag = 100+i;
        if (i==2)
        {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [customTabBar addSubview:btn];
    }
    [self.view addSubview:customTabBar];

}
-(void)btnClickAction:(UIButton *)btn
{
    //NSLog(@"btn.tag:%d",btn.tag);
    for (int i=0; i<5; i++)
    {
        UIButton *mybtn = (UIButton *)[self.view viewWithTag:100+i];
        mybtn.selected = NO;
    }
    btn.selected = YES;
    self.selectedIndex = btn.tag-100;
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

@end
