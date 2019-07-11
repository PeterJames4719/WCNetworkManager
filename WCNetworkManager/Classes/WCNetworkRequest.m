//
//  WCNetworkRequest.m
//  WCNetworkManager
//
//  Created by wubing on 2017/12/5.
//  Copyright © 2017年 wubing. All rights reserved.
//

#import "WCNetworkRequest.h"

extern Class<WCNetworkRequestInterceptorProtocol> _requestInterceptor;

@implementation WCNetworkRequest

- (NSDictionary *)commonHeaders {
    if (_ignoreCommonHeaders) {
        return nil;
    }
    if ([_requestInterceptor respondsToSelector:@selector(commonHeaders)]) {
        return [_requestInterceptor commonHeaders];
    }
    
    return nil;
}

- (NSDictionary *)commonParameters {
    if (_ignoreCommonParameters) {
        return nil;
    }
    if ([_requestInterceptor respondsToSelector:@selector(commonParameters)]) {
        return [_requestInterceptor commonParameters];
    }
    
    return nil;
}

- (void)signRequest:(NSMutableURLRequest *)request {
    if (_ignoreSign) {
        return;
    }
    if ([_requestInterceptor respondsToSelector:@selector(signRequest:)]) {
        [_requestInterceptor signRequest:request];
    }
    
}

@end

@implementation NetworkRequestGet
@end

@implementation NetworkRequestPost
@end

@implementation NetworkRequestPostJson
@end

@implementation NetworkRequestPostFormData
@end

@implementation NetworkRequestDelete
@end

@implementation NetworkRequestPut
@end

@implementation NetworkRequestDownload
@end
