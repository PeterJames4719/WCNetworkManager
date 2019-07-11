//
//  WCNetworkManager.m
//  WCNetworkManager
//
//  Created by wubing on 2017/12/5.
//  Copyright © 2017年 wubing. All rights reserved.
//

#import "WCNetworkManager.h"
#import "AFHTTPSessionManager.h"
#import "MJExtension.h"

Class<WCNetworkRequestInterceptorProtocol> _requestInterceptor;
Class<WCNetworkResponseInterceptorProtocol> _responseInterceptor;

@interface WCNetworkManager()
@property (nonatomic, strong) AFHTTPSessionManager *afManager;
@property (nonatomic, strong) NSMutableDictionary *senderRequestMapper;
@end

@implementation WCNetworkManager
+ (void)setRequestInterceptorClass:(Class<WCNetworkRequestInterceptorProtocol>)cls {
    if ([cls conformsToProtocol:@protocol(WCNetworkRequestInterceptorProtocol)]) {
        _requestInterceptor = cls;
    }
}
+ (void)setResponseInterceptorClass:(Class<WCNetworkResponseInterceptorProtocol>)cls {
    if ([cls conformsToProtocol:@protocol(WCNetworkResponseInterceptorProtocol)]) {
        _responseInterceptor = cls;
    }
}

- (NSMutableDictionary *)senderRequestMapper
{
    if (!_senderRequestMapper) {
        _senderRequestMapper = [NSMutableDictionary dictionary];
    }
    return _senderRequestMapper;
}

- (void)setBaseUrl:(NSString *)baseUrl {
    if (_baseUrl != baseUrl) {
        _afManager = nil;
        _baseUrl = baseUrl;
        id afm = self.afManager;
    }
}

- (AFHTTPSessionManager *)afManager
{
    if (!_afManager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _afManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:_baseUrl] sessionConfiguration:config];
        _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/plain", nil];
        
        // 使用默认
        //_afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _afManager;
}

+ (instancetype)sharedManager
{
    static WCNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WCNetworkManager alloc] init];
    });
    return manager;
}

- (void)sendRequest:(WCNetworkRequest *)request
{
    // 成功
    void (^successBlock) (NSURLSessionDataTask *task, id responseObject) = ^ (NSURLSessionDataTask *task, id responseObject) {
        [self unbindTask:task toSender:request.sender];
        
        WCNetworkResponse *response;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (request.responseCreateBlock) {
                response = request.responseCreateBlock(task, responseObject);
            } else {
                response = [WCNetworkResponse mj_objectWithKeyValues:responseObject];
            }
            response.context = request.context;
            
            if ([_responseInterceptor respondsToSelector:@selector(request:withResponse:)]) {
                [_responseInterceptor request:request withResponse:response];
            }
            
            // 认证失败，取消登录状态
//            if (response.errorCode == kNetworkResponseErrorAuthorize) {
//                [WCUserManager logoutWithoutRequest];
//                [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotificationKey object:nil];
//            }
        } else {
            response = [[WCNetworkResponse alloc] init];
            response.context = request.context;
            response.errorCode = kNetworkResponseError;
            response.errorMsg = @"服务器错误";
        }
        
        // 解析
        if (request.responseParseBlock) {
            request.responseParseBlock(task, responseObject, response);
        } else {
            response.data = responseObject;
        }
        
        // 回调
        if (request.completionBlock) {
            request.completionBlock(response);
        } else {
            if ([request.sender respondsToSelector:@selector(networkRequestCompeletion:)]) {
                [request.sender networkRequestCompeletion:response];
            } else {
                NSLog(@"sender nil");
            }
        }
    };
    
    // 失败
    void (^failureBlock) (NSURLSessionDataTask *task, NSError *error) = ^ (NSURLSessionDataTask *task, NSError *error) {
        [self unbindTask:task toSender:request.sender];
        
        WCNetworkResponse *response = [[WCNetworkResponse alloc] init];
        response.context = request.context;
        if (-999 == error.code) {
            response.errorCode = kNetworkResponseErrorCanceled;
            response.errorMsg = @"请求已取消";
        } else if (-1009 == error.code) {
            response.errorCode = kNetworkResponseErrorNoNet;
            response.errorMsg = @"没有网络";
        } else {
            response.errorCode = kNetworkResponseError;
            response.errorMsg = [NSString stringWithFormat:@"%@(code:%zd)", error.userInfo[@"NSLocalizedDescription"], error.code];
        }
        
        if (request.completionBlock) {
            request.completionBlock(response);
        } else {
            if ([request.sender respondsToSelector:@selector(networkRequestCompeletion:)]) {
                [request.sender networkRequestCompeletion:response];
            } else {
                NSLog(@"sender nil");
            }
        }
    };
    
    // 公共参数
    NSMutableDictionary *totalParameters = [NSMutableDictionary dictionaryWithDictionary:request.commonParameters];
    NSDictionary *paradict = request.parameters;
    [totalParameters addEntriesFromDictionary:paradict];
    if (totalParameters.count == 0) {
        totalParameters = nil;
    }
    
    // url
    NSString *url = request.url;
    url = [[NSURL URLWithString:url relativeToURL:self.afManager.baseURL] absoluteString];
    
    // serializer
    NSError *serializerError;
    NSMutableURLRequest *urlRequest;
    AFHTTPRequestSerializer *serializer = [self requestSerializerForRequest:request];
    
    // GET
    if ([request isKindOfClass:[NetworkRequestGet class]]) {
        urlRequest = [serializer requestWithMethod:@"GET" URLString:url parameters:totalParameters error:&serializerError];
    } else if ([request isKindOfClass:[NetworkRequestPost class]]) {
        urlRequest = [serializer requestWithMethod:@"POST" URLString:url parameters:totalParameters error:&serializerError];
    } else if ([request isKindOfClass:[NetworkRequestPostJson class]]) {
        urlRequest = [serializer requestWithMethod:@"POST" URLString:url parameters:totalParameters error:&serializerError];
    } else if ([request isKindOfClass:[NetworkRequestPostFormData class]]) {
        urlRequest = [serializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:totalParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NetworkRequestPostFormData *postRequest = (NetworkRequestPostFormData *)request;
            if (postRequest.formDataConstructBlock) {
                postRequest.formDataConstructBlock(formData);
            }
        } error:&serializerError];
    } else if ([request isKindOfClass:[NetworkRequestDelete class]]) {
        urlRequest = [serializer requestWithMethod:@"DELETE" URLString:url parameters:totalParameters error:&serializerError];
    } else if ([request isKindOfClass:[NetworkRequestPut class]]) {
        urlRequest = [serializer requestWithMethod:@"PUT" URLString:url parameters:totalParameters error:&serializerError];
    } else {
        urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    }
    
    if (serializerError) {
        failureBlock(nil, serializerError);
        return;
    }
    
    // 签名
    [request signRequest:urlRequest];
    
    __block NSURLSessionDataTask *dataTask = nil;
    if ([request isKindOfClass:[NetworkRequestPostFormData class]]) {
        dataTask = [self.afManager uploadTaskWithStreamedRequest:urlRequest progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"imageUpload-> progress:%lf", uploadProgress.fractionCompleted);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                if (failureBlock) {
                    failureBlock(dataTask, error);
                }
            } else {
                if (successBlock) {
                    successBlock(dataTask, responseObject);
                }
            }
        }];
    } else if ([request isKindOfClass:[NetworkRequestDownload class]]) {
        NetworkRequestDownload *downloadRequest = (NetworkRequestDownload *)request;
        dataTask = [self.afManager downloadTaskWithRequest:urlRequest  progress:^(NSProgress * _Nonnull downloadProgress) {
            //NSLog(@"download ->: %lld/%lld", downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            CGFloat currentProgress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            if (downloadRequest.downloadProgressBlock) {
                downloadRequest.downloadProgressBlock(currentProgress);
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSLog(@"download -> path:%@", downloadRequest.savePath);
            NSURL *fileUrl = [NSURL fileURLWithPath:downloadRequest.savePath];
            [[NSFileManager defaultManager] removeItemAtURL:fileUrl error:nil];
            return fileUrl;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (downloadRequest.downloadCompletionBlock) {
                downloadRequest.downloadCompletionBlock(filePath, error);
            }
        }];
    } else {
        dataTask = [self.afManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                if (failureBlock) {
                    failureBlock(dataTask, error);
                }
            } else {
                if (successBlock) {
                    successBlock(dataTask, responseObject);
                }
            }
        }];
    }
    [dataTask resume];
    
    // 绑定
    [self bindTask:dataTask toSender:request.sender];
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(WCNetworkRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if ([request isKindOfClass:[NetworkRequestPostJson class]] || [request isKindOfClass:[NetworkRequestPut class]]) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    if (request.timeoutInterval > 0) {
        requestSerializer.timeoutInterval = request.timeoutInterval;
    }
    
    // 添加头部
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.commonHeaders];
    [headers addEntriesFromDictionary:request.headers];
    if (headers) {
        for (NSString *key in headers) {
            [requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    return requestSerializer;
}

- (void)unbindTask:(NSURLSessionDataTask *)task toSender:(id)sender
{
    NSLog(@"mapper->remove:%@", task.currentRequest.URL);
    NSMutableArray *requests = [self.senderRequestMapper objectForKey:[sender description]];
    [requests removeObject:task];
}

- (void)bindTask:(NSURLSessionDataTask *)task toSender:(id)sender
{
    if (!sender) {
        return;
    }
    NSLog(@"mapper->add:%@", task.currentRequest.URL);
    NSMutableArray *requests = [self.senderRequestMapper objectForKey:[sender description]];
    if (requests) {
        [requests addObject:task];
    } else {
        [self.senderRequestMapper setObject:[NSMutableArray array] forKey:[sender description]];
    }
}

- (void)cancelRequestsFor:(id)sender
{
    NSMutableArray *requests = [self.senderRequestMapper objectForKey:[sender description]];
    [requests makeObjectsPerformSelector:@selector(cancel)];
}


@end
