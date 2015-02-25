//
//  RepostViewController.m
//  weico
//
//  Created by xuyazhong on 15/2/25.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "RepostViewController.h"
#import "AFNetworking.h"
#import "ShareToken.h"


@interface RepostViewController ()
{
    ShareToken *token;
}
@end

@implementation RepostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    token = [ShareToken sharedToken];
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    self.view.backgroundColor = [UIColor clearColor];
    UIButton *repostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    repostBtn.frame = CGRectMake(0, 0, 80, 40);
    [repostBtn setTitle:@"发送" forState:UIControlStateNormal];
    [repostBtn addTarget:self action:@selector(repostAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:repostBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 80, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = left;
    
}
-(void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)repostAction
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:token.token,@"access_token",_model.tid,@"id", nil];
    [manager POST:kURLRepost parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"success:%@",responseObject);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failed:%@",error.localizedDescription);
    }];
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

@end
