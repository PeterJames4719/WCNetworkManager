//
//  LKADURLProtocol.m
//  LKADSDKDemo
//
//  Created by 兵伍 on 2019/7/15.
//  Copyright © 2019 兵伍. All rights reserved.
//

#import "LKADURLProtocol.h"

@implementation LKADURLProtocol

+(BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSLog(@"canInit");
    return YES;
}

+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSLog(@"cannonical");
    return request;
}

@end
