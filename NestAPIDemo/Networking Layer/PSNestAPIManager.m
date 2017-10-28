//
//  PSNestAPIManager.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/18/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestAPIManager.h"

@interface PSNestAPIManager () <NSURLSessionDataDelegate>

@property (strong, nonatomic) NSURLSession *urlSession;

@end

@implementation PSNestAPIManager

- (NSURLSession *)urlSession {
    if (!_urlSession) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        sessionConfiguration.timeoutIntervalForRequest = 30;
        sessionConfiguration.timeoutIntervalForResource = 45;
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        _urlSession = urlSession;
    }
    
    return _urlSession;
}

- (void)performRequest:(NSURLRequest *)request {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue currentQueue]];
    
    NSURLSessionDataTask *eventSourceTask = [session dataTaskWithRequest:request];
    [eventSourceTask resume];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
}

- (void)performRequest:(NSURLRequest *)request
               success:(void (^)(NSData *data))success
               failure:(void (^)(NSError *error))failure {
    [self performRequest:request success:success redirect:nil failure:failure];
}

- (void)performRequest:(NSURLRequest *)request
               success:(void (^)(NSData *data))success
              redirect:(void (^)(NSHTTPURLResponse *responseURL))redirect
               failure:(void (^)(NSError *error))failure {
    NSURLSessionTask *sessionTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ((long)[httpResponse statusCode] == 401 || (long)[httpResponse statusCode] == 307) {

            // Check if a returned 401 is a true 401, sometimes it's a redirect.
            //   See https://developers.nest.com/documentation/cloud/how-to-handle-redirects
            //   for more information.
            
            NSDictionary *responseHeaders = [httpResponse allHeaderFields];
            if ([[responseHeaders objectForKey:@"Content-Length"] isEqual: @"0"]) {
                // This is a true 401
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                });
                failure(error);
            } else {
                // It's actually a redirect
                redirect(httpResponse);
            }
        } else if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
            failure(error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
            success(data);
        }
    }];
    
    [sessionTask resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((long)[httpResponse statusCode] == 401 || (long)[httpResponse statusCode] == 307) {
        // Check if a returned 401 is a true 401, sometimes it's a redirect.
        //   See https://developers.nest.com/documentation/cloud/how-to-handle-redirects
        //   for more information.
        NSDictionary *responseHeaders = [httpResponse allHeaderFields];
        if ([[responseHeaders objectForKey:@"Content-Length"] isEqual: @"0"]) {
            // This is a true 401
            NSError *error = [NSError errorWithDomain:@"com.fireflydevelop.NestAPIDemo" code:1 userInfo:nil];
            [self.delegate nestAPIManager:self didFinishRequestWithError:error];
        } else {
            // It's actually a redirect
            [self.delegate nestAPIManager:self didRecieveRedirectURLWithResponse:response];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });

    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.delegate nestAPIManager:self didRecieveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    [self.delegate nestAPIManager:self didFinishRequestWithError:error];
}

@end
