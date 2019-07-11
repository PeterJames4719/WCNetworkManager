//
//  WCNetworkRequestInterceptor.m
//  WealthCatApp
//
//  Created by 兵伍 on 2019/7/9.
//  Copyright © 2019 兵伍. All rights reserved.
//

#import "WCNetworkRequestInterceptor.h"

@implementation WCNetworkRequestInterceptor

+ (NSDictionary *)commonParameters {
    return @{@"version": @"1.0"};
}

+ (NSDictionary *)commonHeaders {
    return @{@"platfrom": @"ios"};
}

+ (void)signRequest:(NSMutableURLRequest *)request {
    [request setValue:@"signature" forHTTPHeaderField:@"signature"];
    
}
@end
