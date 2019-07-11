//
//  WCNetworkReponseErrorCallback.m
//  WealthCatApp
//
//  Created by 兵伍 on 2019/7/9.
//  Copyright © 2019 兵伍. All rights reserved.
//

#import "WCNetworkReponseInterceptor.h"
extern NSString * const LogoutNotificationKey;

@implementation WCNetworkReponseInterceptor

+ (NSDictionary *)replacedKeyForPropertyNameFromJson {
    return @{
             @"errorCode" : @"errCode",
             @"errorMsg" : @"errMsg"
             };
}

+ (void)request:(WCNetworkRequest *)request withResponse:(WCNetworkResponse *)response {
    // 认证失败，取消登录状态
    if (response.errorCode != 0) {
        NSLog(@"response error:%zd", response.errorCode);
    }
}

@end
