//
//  WBViewController.m
//  WCNetworkManager
//
//  Created by PeterJames4719 on 07/11/2019.
//  Copyright (c) 2019 PeterJames4719. All rights reserved.
//

#import "WBViewController.h"
#import <WCNetworkManager.h>
#import "WCNetworkReponseInterceptor.h"
#import "WCNetworkRequestInterceptor.h"

@interface WBViewController ()

@end

@implementation WBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[WCNetworkManager sharedManager] setBaseUrl:@"https://httpbin.org"];
    [WCNetworkManager setRequestInterceptorClass:[WCNetworkRequestInterceptor class ]];
    [WCNetworkManager setResponseInterceptorClass:[WCNetworkReponseInterceptor class]];
    
    [self get];
    [self get_2];
    [self post];
    [self post_2];
    [self post_json];
}

- (void)get {
    NetworkRequestGet *request = [NetworkRequestGet new];
    request.url = @"get";
    request.parameters = @{@"p1": @"para1"};
    request.headers = @{@"h1": @"header1"};
    
    request.responseParseBlock = ^(NSURLSessionDataTask *task, id originResponse, WCNetworkResponse *response) {
        NSLog(@"get response:%@", originResponse);
    };
    
    request.completionBlock = ^(WCNetworkResponse *response) {
        
    };
    
    [[WCNetworkManager sharedManager] sendRequest:request];
}

- (void)get_2 {
    NetworkRequestGet *request = [NetworkRequestGet new];
    request.url = @"get";
    request.parameters = @{@"p1": @"para1"};
    request.headers = @{@"h1": @"header1"};
    request.ignoreSign = YES;
    request.ignoreCommonHeaders = YES;
    request.ignoreCommonParameters = YES;
    
    request.responseParseBlock = ^(NSURLSessionDataTask *task, id originResponse, WCNetworkResponse *response) {
        NSLog(@"get2 response:%@", originResponse);
    };
    
    request.completionBlock = ^(WCNetworkResponse *response) {
        
    };
    
    [[WCNetworkManager sharedManager] sendRequest:request];
}

- (void)post {
    NetworkRequestPost *request = [NetworkRequestPost new];
    request.url = @"post";
    request.parameters = @{@"p1": @"para1"};
    request.headers = @{@"h1": @"header1"};
    
    request.responseParseBlock = ^(NSURLSessionDataTask *task, id originResponse, WCNetworkResponse *response) {
        NSLog(@"post response:%@", originResponse);
    };
    
    request.completionBlock = ^(WCNetworkResponse *response) {
        
    };
    
    [[WCNetworkManager sharedManager] sendRequest:request];
}

- (void)post_2 {
    NetworkRequestPost *request = [NetworkRequestPost new];
    request.url = @"post";
    request.parameters = @{@"p1": @"para1"};
    request.headers = @{@"h1": @"header1"};
    request.ignoreSign = YES;
    request.ignoreCommonHeaders = YES;
    request.ignoreCommonParameters = YES;
    
    request.responseParseBlock = ^(NSURLSessionDataTask *task, id originResponse, WCNetworkResponse *response) {
        NSLog(@"post2 response:%@", originResponse);
    };
    
    request.completionBlock = ^(WCNetworkResponse *response) {
        
    };
    
    [[WCNetworkManager sharedManager] sendRequest:request];
}

- (void)post_json {
    NetworkRequestPostJson *request = [NetworkRequestPostJson new];
    request.url = @"post";
    request.parameters = @{@"p1": @"para1"};
    request.headers = @{@"h1": @"header1"};
    
    request.responseParseBlock = ^(NSURLSessionDataTask *task, id originResponse, WCNetworkResponse *response) {
        NSLog(@"post json response:%@", originResponse);
    };
    
    request.completionBlock = ^(WCNetworkResponse *response) {
        
    };
    
    [[WCNetworkManager sharedManager] sendRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
