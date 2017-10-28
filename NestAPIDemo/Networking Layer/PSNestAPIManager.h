//
//  PSNestAPIManager.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/18/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PSNestAPIManagerDelegate

- (void)nestAPIManager:(id)manager didRecieveRedirectURLWithResponse:(NSURLResponse *)response;
- (void)nestAPIManager:(id)manager didRecieveData:(NSData *)data;
- (void)nestAPIManager:(id)manager didFinishRequestWithError:(NSError *)error;

@end

@interface PSNestAPIManager : NSObject

@property (weak, nonatomic) id <PSNestAPIManagerDelegate> delegate;

- (void)performRequest:(NSURLRequest *)request
               success:(void (^)(NSData *data))success
              redirect:(void (^)(NSHTTPURLResponse *responseURL))redirect
               failure:(void (^)(NSError *error))failure;

- (void)performRequest:(NSURLRequest *)request
               success:(void (^)(NSData *data))success
               failure:(void (^)(NSError *error))failure;

- (void)performRequest:(NSURLRequest *)request;

@end
