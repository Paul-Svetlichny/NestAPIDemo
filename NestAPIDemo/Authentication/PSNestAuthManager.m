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

@property (strong, nonatomic) PSNestSessionManager *nestSessionManager;

@end

@implementation PSNestAuthManager

- (instancetype)init {
    if (self = [super init]) {
        _nestSessionManager = [[PSNestSessionManager alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    }
    
    return self;
}

#pragma mark - Authentication

- (void)authenticateWithAuthCode:(NSString *)authCode success:(void (^)(NSString *accessToken))success failure:(void (^)(NSError *error))failure {
    
    PSNestRequestBuilder *nestRequestBuilder = [[PSNestRequestBuilder alloc] init];
    NSMutableURLRequest *authRequest = [nestRequestBuilder authenticationRequestWithAuthCode:authCode];
    
    PSNestAPIManager *nestAPIManager = [[PSNestAPIManager alloc] initWithURLSession:_nestSessionManager.urlSession];
    [nestAPIManager performRequest:authRequest success:^(NSData *data) {
        PSNestResponseParser *responseParser = [[PSNestResponseParser alloc] init];
        NSDictionary *accessTokenDictionary = [responseParser responseDictionaryFromResponseData:data];
        if (!accessTokenDictionary[@"error"]) {
            [_nestSessionManager setAccessTokenWithDictionary:accessTokenDictionary];
            success(_nestSessionManager.accessToken);
        } else {
            failure(accessTokenDictionary[@"error"]);
        }
    } redirect:^(NSHTTPURLResponse *responseURL) {
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
