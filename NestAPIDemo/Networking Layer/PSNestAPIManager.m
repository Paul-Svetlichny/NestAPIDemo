//
//  PSNestAPIManager.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/18/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestAPIManager.h"

@interface PSNestAPIManager ()

@property (strong, nonatomic) NSURLSession *urlSession;

@end

@implementation PSNestAPIManager

- (instancetype)initWithURLSession:(NSURLSession *)urlSession {
    if (self = [super init]) {
        _urlSession = urlSession;
    }
    
    return self;
}

- (void)performRequest:(NSMutableURLRequest *)request
               success:(void (^)(NSData *data))success
              redirect:(void (^)(NSHTTPURLResponse *responseURL))redirect
               failure:(void (^)(NSError *error))failure {
    NSURLSessionTask *sessionTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ((long)[httpResponse statusCode] == 401 || (long)[httpResponse statusCode] == 307) {

            // Check if a returned 401 is a true 401, sometimes it's a redirect.
            //   See https://developers.nest.com/documentation/cloud/how-to-handle-redirects
            //   for more information.
            
            NSDictionary *responseHeaders = [httpResponse allHeaderFields];
            if ([[responseHeaders objectForKey:@"Content-Length"] isEqual: @"0"]) {
                // This is a true 401
                failure(error);
            } else {
                // It's actually a redirect
                redirect(httpResponse);
            }
        } else if (error) {
            failure(error);
        } else {
            success(data);
        }
    }];
    
    [sessionTask resume];
}

@end
