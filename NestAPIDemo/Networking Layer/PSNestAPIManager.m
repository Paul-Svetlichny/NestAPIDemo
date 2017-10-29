//
//  PSNestAPIManager.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/18/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestAPIManager.h"

@interface PSNestAPIManager () <NSURLSessionDataDelegate>

@end

@implementation PSNestAPIManager

- (NSURLSession *)urlSession {
    if (!_urlSession) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:self
                                                         delegateQueue:[NSOperationQueue currentQueue]];
    }
    
    return _urlSession;
}

- (void)performRequest:(NSURLRequest *)request {
    NSURLSessionDataTask *eventSourceTask = [self.urlSession dataTaskWithRequest:request];
    [eventSourceTask resume];
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
    
    if (!request) {
        failure([NSError errorWithDomain:@"com.fireflydevelop.NestAPIDemo" code:2 userInfo:@{NSLocalizedDescriptionKey:@"Input request should not be nil"}]);
        return;
    }

    NSURLSessionTask *sessionTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        //  URL Redirect if statusCode is 401 or 307
        if ((long)[httpResponse statusCode] == 401 || (long)[httpResponse statusCode] == 307) {
            NSDictionary *responseHeaders = [httpResponse allHeaderFields];
            if ([[responseHeaders objectForKey:@"Content-Length"] isEqual: @"0"]) {
                failure(error);
            } else {
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

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((long)[httpResponse statusCode] == 401 || (long)[httpResponse statusCode] == 307) {
        NSDictionary *responseHeaders = [httpResponse allHeaderFields];
        if ([[responseHeaders objectForKey:@"Content-Length"] isEqual: @"0"]) {
            NSError *error = [NSError errorWithDomain:@"com.fireflydevelop.NestAPIDemo" code:1 userInfo:nil];
            [self.delegate nestAPIManager:self didFinishRequestWithError:error];
        } else {
            [self.delegate nestAPIManager:self didRecieveRedirectURLWithResponse:response];
        }
    }

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
