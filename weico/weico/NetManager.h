//
//  NetManager.h
//  NewsProject
//
//  Created by xyz on 15-2-25.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <Foundation/Foundation.h>


//用于封装网络交互的操作
//网络请求用AFNetWorking
typedef void(^DownloadFinishedBlock)(id resposeObj);
typedef void(^DownloadFailedBlock)(NSString *errorMsg);

@interface NetManager : NSObject

//http协议 get 请求
+(void)requestWithString:(NSString *)urlString finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock;




@end
