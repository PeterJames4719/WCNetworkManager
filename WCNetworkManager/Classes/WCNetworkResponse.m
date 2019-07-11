//
//  WCNetworkResponse.m
//  WCNetworkManager
//
//  Created by wubing on 2017/12/5.
//  Copyright © 2017年 wubing. All rights reserved.
//

#import "WCNetworkResponse.h"

extern Class<WCNetworkResponseInterceptorProtocol> _responseInterceptor;

@implementation WCNetworkResponse

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    if ([_responseInterceptor respondsToSelector:@selector(replacedKeyForPropertyNameFromJson)]) {
        return [_responseInterceptor replacedKeyForPropertyNameFromJson];
    }
    return nil;
}

@end
