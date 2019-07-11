//
//  WCNetworkResponseErrorCallbackProtocol.h
//  WealthCatApp
//
//  Created by 兵伍 on 2019/7/9.
//  Copyright © 2019 兵伍. All rights reserved.
//

#ifndef WCNetworkResponseErrorCallbackProtocol_h
#define WCNetworkResponseErrorCallbackProtocol_h

@class WCNetworkRequest;
@class WCNetworkResponse;
@protocol WCNetworkResponseInterceptorProtocol <NSObject>
+ (NSDictionary *)replacedKeyForPropertyNameFromJson;
+ (void)request:(WCNetworkRequest *)request withResponse:(WCNetworkResponse *)response;

@end

#endif /* WCNetworkResponseErrorCallbackProtocol_h */
