//
//  PSNestAuthManager.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestAuthManager.h"
#import "PSNestAPIManager.h"
#import "PSNestSessionManager.h"
#import "PSNestRequestBuilder.h"
#import "PSNestResponseParser.h"

@interface PSNestAuthManager ()

@end

@implementation PSNestAuthManager

- (PSNestSessionManager *)nestSessionManager {
    if (!_nestSessionManager) {
        _nestSessionManager = [[PSNestSessionManager alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    }
    
    return _nestSessionManager;
}

- (PSNestAPIManager *)nestAPIManager {
    if (!_nestAPIManager) {
        _nestAPIManager = [[PSNestAPIManager alloc] initWithURLSession:self.nestSessionManager.urlSession];
    }
    
    return _nestAPIManager;
}

- (PSNestResponseParser *)responseParser {
    if (!_responseParser) {
        _responseParser = [[PSNestResponseParser alloc] init];
    }
    
    return _responseParser;
}

#pragma mark - Authentication

- (void)authenticateWithAuthRequest:(NSURLRequest *)authRequest success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    
    [self.nestAPIManager performRequest:authRequest success:^(NSData *data) {
        
        NSDictionary *accessTokenDictionary = [self.responseParser responseDictionaryFromResponseData:data];
        if (!accessTokenDictionary[@"error"]) {
            [self.nestSessionManager setAccessTokenWithDictionary:accessTokenDictionary];
            success();
        } else {
            failure(accessTokenDictionary[@"error"]);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
