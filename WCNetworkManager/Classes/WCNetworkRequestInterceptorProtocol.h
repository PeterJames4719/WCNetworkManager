//
//  WCNetworkRequestInterceptorProtocol.h
//  WealthCatApp
//
//  Created by 兵伍 on 2019/7/9.
//  Copyright © 2019 兵伍. All rights reserved.
//

#ifndef WCNetworkRequestInterceptorProtocol_h
#define WCNetworkRequestInterceptorProtocol_h

@protocol WCNetworkRequestInterceptorProtocol <NSObject>
+ (NSDictionary *)commonHeaders;
+ (NSDictionary *)commonParameters;
+ (void)signRequest:(NSMutableURLRequest *)request;
@end

#endif /* WCNetworkRequestInterceptorProtocol_h */
