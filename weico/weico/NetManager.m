//
//  NetManager.m
//  NewsProject
//
//  Created by xyz on 15-2-25.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "NetManager.h"
#import "AFNetworking.h"


@implementation NetManager


//http协议 get 请求
+(void)requestWithString:(NSString *)urlString dict:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock
{
    //拼接路径
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/tweet"];
    NSLog(@"path:%@",path);
    //数据指定路径下的文件存在,并且没有超时,则使用缓存,否则重新请求数据
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        //使用数据缓存,而不是请求数据
        NSData *data = [NSData dataWithContentsOfFile:path];
        //执行block,并传出data
        finishedBlock(data);
        
    }else
    {
        //后续加上数据缓存
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //block 返回为NSData
        [manager GET:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //每个数据都有唯一的请求地址,数据为NSData,写到本地的文件中,文件名用请求地址的MD5加密之后的字符串
             //MD5为对数据的一种加密方式
             //调用完成block
             //本地的缓存数据,客户端可以规定一个有效时间,有效时间范围内使用缓存数据,否则重新发起数据请求
             
             //将请求下来的数据写到本地
             if ([responseObject isKindOfClass:[NSData class]])
             {
                 NSData *resposeData = (NSData *)responseObject;
                 [resposeData writeToFile:path atomically:YES];
                 finishedBlock(resposeData);
             }else
             {
                 NSLog(@"数据格式错误!");
             }
             //finishedBlock(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             //调用完成block
             failedBlock(error.localizedDescription);
         }];
    }
    
    
}


@end
