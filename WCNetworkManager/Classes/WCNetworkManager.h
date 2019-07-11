//
//  WCNetworkManager.h
//  WCNetworkManager
//
//  Created by wubing on 2017/12/5.
//  Copyright © 2017年 wubing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCNetworkRequest.h"
#import "WCNetworkResponse.h"

@protocol NetworkManagerDelegate <NSObject>
@optional
- (void)networkRequestCompeletion:(WCNetworkResponse *)response;
@end


@interface WCNetworkManager : NSObject
@property (nonatomic, strong) NSString *baseUrl;
+ (instancetype)sharedManager;
- (void)sendRequest:(WCNetworkRequest *)request;
- (void)cancelRequestsFor:(id)sender;
+ (void)setRequestInterceptorClass:(Class<WCNetworkRequestInterceptorProtocol>)cls;
+ (void)setResponseInterceptorClass:(Class<WCNetworkResponseInterceptorProtocol>)cls;
@end
