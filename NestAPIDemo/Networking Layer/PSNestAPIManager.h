//
//  PSNestAPIManager.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/18/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSNestAPIManager : NSObject

- (instancetype)initWithURLSession:(NSURLSession *)urlSession;

- (void)performRequest:(NSMutableURLRequest *)request
               success:(void (^)(NSData *data))success
              redirect:(void (^)(NSHTTPURLResponse *responseURL))redirect
               failure:(void (^)(NSError *error))failure;

@end
