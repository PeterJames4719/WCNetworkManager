//
//  WCNetworkRequest.h
//  WCNetworkManager
//
//  Created by wubing on 2017/12/5.
//  Copyright © 2017年 wubing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"
#import "WCNetworkResponse.h"
#import "WCNetworkRequestInterceptorProtocol.h"

@protocol NetworkManagerDelegate;


// Base
@interface WCNetworkRequest : NSObject
@property (nonatomic, copy) NSString *context;
@property (nonatomic, weak) id sender;
@property (nonatomic, weak) id <NetworkManagerDelegate>delegate;
@property (nonatomic, assign) NSInteger timeoutInterval;
@property (nonatomic, copy) NSString *url;

// 参数
@property (nonatomic, strong) NSDictionary *parameters;
// 公共参数
@property (nonatomic, strong, readonly) NSDictionary *commonParameters;
// 头
@property (nonatomic, strong) NSDictionary *headers;
// 公共头
@property (nonatomic, strong, readonly) NSDictionary *commonHeaders;

@property (nonatomic, copy) WCNetworkResponse * (^responseCreateBlock) (NSURLSessionDataTask *task, id originResponse);
@property (nonatomic, copy) void (^responseParseBlock) (NSURLSessionDataTask *task, id originResponse, WCNetworkResponse *response);
@property (nonatomic, copy) void (^completionBlock) (WCNetworkResponse *response);
@property (nonatomic, assign) BOOL ignoreCommonHeaders;
@property (nonatomic, assign) BOOL ignoreCommonParameters;
@property (nonatomic, assign) BOOL ignoreSign;


- (void)signRequest:(NSMutableURLRequest *)request;

@end

// GET
@interface NetworkRequestGet : WCNetworkRequest
@end

@interface NetworkRequestPost : WCNetworkRequest
@end

// POST<json>
@interface NetworkRequestPostJson : WCNetworkRequest
@end

// POST<form-data>
@interface NetworkRequestPostFormData : WCNetworkRequest
@property (nonatomic, copy) void (^formDataConstructBlock) (id<AFMultipartFormData> formData);
@end

// DELETE
@interface NetworkRequestDelete : WCNetworkRequest

@end

// PUT
@interface NetworkRequestPut : WCNetworkRequest

@end

@interface NetworkRequestDownload : WCNetworkRequest
@property (nonatomic, copy) void (^downloadProgressBlock) (CGFloat progress);
@property (nonatomic, copy) void (^downloadCompletionBlock) (NSURL *url, NSError *error);

@property (nonatomic, copy) NSString *savePath;
@property (nonatomic, copy) NSString *tmpPath;
@end
