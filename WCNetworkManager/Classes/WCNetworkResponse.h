//
//  WCNetworkResponse.h
//  WCNetworkManager
//
//  Created by wubing on 2017/12/5.
//  Copyright © 2017年 wubing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCNetworkResponseInterceptorProtocol.h"

typedef NS_ENUM(NSInteger, WCNetworkResponseError) {
    // 通用
    kNetworkResponseErrorNone = 0,          // 正常
    kNetworkResponseErrorNoNet = 20190108,  // 无网
    kNetworkResponseErrorCanceled,          // 取消
    kNetworkResponseErrorNoData,            // 无数据
    kNetworkResponseErrorNoMoreData,        // 无更多数据
    kNetworkResponseError,                  // 通用服务器错误
    
//    // 业务
//    kNetworkResponseErrorAuthorize = 4001,             // 认证失败
//    kNetworkResponseErrorAuthorize_bkb = 9995,          // 认证失败
//    kNetworkResponseErrorCircleAlreadyJoined = 60001,   // 已经加入过社群
//    kNetworkResponseErrorTopicDeleted = 8996,           // 主题已删除
//    kNetworkResponseErrorNoDataServer = 9996,           // 无数据
};

@interface WCNetworkResponse : NSObject
@property (nonatomic, copy) NSString *context;
@property (nonatomic, assign) WCNetworkResponseError errorCode;
@property (nonatomic, strong) NSString *errorMsg;
@property (nonatomic, strong) id data;
@end
