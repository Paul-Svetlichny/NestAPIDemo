//
//  PSNestRequestBuilder.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestRequestBuilder.h"
#import "PSNestURLAggregator.h"

@interface PSNestRequestBuilder ()

@property (strong, nonatomic) PSNestURLAggregator *urlAggregator;

@end

@implementation PSNestRequestBuilder

- (instancetype)init {
    if (self = [super init]) {
        _urlAggregator = [[PSNestURLAggregator alloc] init];
    }
    
    return self;
}

- (NSMutableURLRequest *)requestForBaseURLString:(NSString *)baseURLString andPath:(NSString *)path andRequestMethod:(NSString *)requestMethod withData:(NSData *)data andAccessToken:(NSString *)accessToken {
    NSString *authBearer = [NSString stringWithFormat:@"Bearer %@", accessToken];
    
    if (!baseURLString || !requestMethod || !accessToken) {
        return nil;
    }
    
    NSString *URL = baseURLString;
    if (path.length > 0) {
        URL = [URL stringByAppendingPathComponent:path];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    if ([requestMethod isEqualToString:@"GET"]) {
        [request setValue:@"text/event-stream" forHTTPHeaderField:@"Accept"];
    } else {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    [request setValue:authBearer forHTTPHeaderField:@"Authorization"];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:requestMethod];
    
    if (data) {
        [request setHTTPBody:data];
    }
    
    return request;
}

- (NSMutableURLRequest *)authenticationRequestWithAuthCode:(NSString *)authCode {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[_urlAggregator authURLWithAuthCode:authCode] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

- (NSURLRequest *)loginRequest {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[_urlAggregator loginURL]];
    
    return request;
}

@end
