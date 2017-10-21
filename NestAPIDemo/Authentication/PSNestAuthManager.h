//
//  PSNestAuthManager.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSNestSessionManager;
@class PSNestResponseParser;
@class PSNestAPIManager;

@interface PSNestAuthManager : NSObject

@property (strong, nonatomic) PSNestSessionManager *nestSessionManager;
@property (strong, nonatomic) PSNestResponseParser *responseParser;
@property (strong, nonatomic) PSNestAPIManager *nestAPIManager;

- (void)authenticateWithAuthRequest:(NSURLRequest *)authRequest success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
