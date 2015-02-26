//
//  MyTabBarViewController.m
//  Weico
//
//  Created by xuyazhong on 15/2/18.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "SearchViewController.h"
#import "MeViewController.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    HomeViewController *view1 = [[HomeViewController alloc]init];
    UINavigationController *nvc1 = [[UINavigationController alloc]initWithRootViewController:view1];
    
    MessageViewController *view2 = [[MessageViewController alloc]init];
    UINavigationController *nvc2 = [[UINavigationController alloc]initWithRootViewController:view2];
    
    SearchViewController *view3 = [[SearchViewController alloc]init];
    UINavigationController *nvc3 = [[UINavigationController alloc]initWithRootViewController:view3];
    
    MeViewController *view4 = [[MeViewController alloc]init];
    UINavigationController *nvc4 = [[UINavigationController alloc]initWithRootViewController:view4];
    

    
    NSArray *array = [NSArray arrayWithObjects:nvc1,nvc2,nvc3,nvc4, nil];
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
    
    NSArray *norArr = [NSArray arrayWithObjects:@"tab_favlist_selected",@"tab_user_comments_selected",@"tab_user_home_groups_selected",@"tab_user_at_selected", nil];
    
    //NSArray *selArr = [NSArray arrayWithObjects:@"home_tab_icon_1_selected",@"home_tab_icon_2_selected",@"home_tab_icon_3_selected",@"home_tab_icon_4_selected", nil];
    
    for (int i=0; i<norArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(30+65*i, 0, 65, 45);
        //btn.tintColor = [UIColor clearColor];
        [btn setImage:[UIImage imageNamed:norArr[i]] forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:selArr[i]] forState:UIControlStateSelected];
        btn.tag = 100+i;
        if (i==0)
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
    for (int i=0; i<4; i++)
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
