//
//  PSNestSessionManager.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestSessionManager.h"

@interface PSNestSessionManager ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) NestAccessToken *nestAccessToken;

@end

@implementation PSNestSessionManager

@synthesize nestAccessToken = _nestAccessToken;

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults {
    if (self = [super init]) {
        _userDefaults = userDefaults;
    }
    
    return self;
}

- (NSURLSession *)urlSession {
    if (!_urlSession) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        sessionConfiguration.timeoutIntervalForRequest = 30;
        sessionConfiguration.timeoutIntervalForResource = 45;
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
        _urlSession = urlSession;
    }
    
    return _urlSession;
}

#pragma mark - Session Flow

- (BOOL)isValidSession {
    if ([self.nestAccessToken isValid]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Access Token Section

- (void)setAccessTokenWithDictionary:(NSDictionary *)accessTokenDictionary {
    NestAccessToken *nestAccessToken = [NestAccessToken tokenWithTokenString:accessTokenDictionary[@"access_token"] expiresIn:[accessTokenDictionary[@"expires_in"] longValue]];
    
    self.nestAccessToken = nestAccessToken;
}

- (NSString *)accessToken {
    if ([self isValidSession]) {
        return self.nestAccessToken.token;
    }
    
    return nil;
}

- (NestAccessToken *)nestAccessToken {
    if (!_nestAccessToken) {
        
        NSData *encodedToken = [self.userDefaults objectForKey:@"nestAccessToken"];
        
        if (!encodedToken) {
            return nil;
        }
        
        _nestAccessToken = [NSKeyedUnarchiver unarchiveObjectWithData:encodedToken];
    }
    
    return _nestAccessToken;
}

- (void)setNestAccessToken:(NestAccessToken *)accessToken {
    _nestAccessToken = accessToken;
    
    NSData *encodedToken = [NSKeyedArchiver archivedDataWithRootObject:_nestAccessToken];
    
    [self.userDefaults setObject:encodedToken forKey:@"nestAccessToken"];
    [self.userDefaults synchronize];
}

- (void)invalidateAccessToken {
    _accessToken = nil;
    [self.userDefaults removeObjectForKey:@"nestAccessToken"];
    [self.userDefaults synchronize];
}

@end
