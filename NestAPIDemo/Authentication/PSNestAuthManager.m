//
//  PSNestAuthManager.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestAuthManager.h"
#import "Settings.h"

@interface PSNestAuthManager ()

@property (strong, nonatomic) NSURLSession *urlSession;

/**
 *  NSUserDefaults property dependency injection
 */
@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation PSNestAuthManager

@synthesize accessToken = _accessToken;

+ (PSNestAuthManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static PSNestAuthManager *sharedManager = nil;

    dispatch_once(&onceToken, ^{
        sharedManager = [[PSNestAuthManager alloc] init];
    });
    
    return sharedManager;
}

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

#pragma mark - Session Flow

- (BOOL)isValidSession {
    if ([self.accessToken isValid]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Requests

- (NSURLRequest *)loginRequest {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@/login/oauth2?client_id=%@&state=%@", NestCurrentAPIDomain, NestClientID, NestState]]];
    
    return request;
}

#pragma mark - Access Token Section

- (NestAccessToken *)accessToken {
    if (!_accessToken) {
        
        NSData *encodedToken = [self.userDefaults objectForKey:@"nestAccessToken"];
        
        if (!encodedToken) {
            return nil;
        }
        
        _accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:encodedToken];
    }
    
    return _accessToken;
}

- (void)setAccessToken:(NestAccessToken *)accessToken {
    _accessToken = accessToken;
    NSData *encodedToken = [NSKeyedArchiver archivedDataWithRootObject:_accessToken];
    [self.userDefaults setObject:encodedToken forKey:@"nestAccessToken"];
    [self.userDefaults synchronize];
}

- (void)invalidateAccessToken {
    _accessToken = nil;
    [self.userDefaults removeObjectForKey:@"nestAccessToken"];
    [self.userDefaults synchronize];
}

#pragma mark - Authentication

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

- (NSURL *)authURLForAuthCode:(NSString *)authCode {
    if (!authCode) {
        return nil;
    }
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://api.%@/oauth2/access_token?code=%@&client_id=%@&client_secret=%@&grant_type=authorization_code", NestCurrentAPIDomain, authCode, NestClientID, NestClientSecret]];
    
    return url;
}

- (void)authenticateWithAuthCode:(NSString *)authCode success:(void (^)(NSString *accessToken))success failure:(void (^)(NSError *error))failure {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });

    NSURL *authURL = [self authURLForAuthCode:authCode];
    
    if (!authURL) {
        failure(nil);
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:authURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionTask *sessionTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });

        if (!error) {
            NSError *tokenError;
            self.accessToken = [self accessTokenFromServerData:data andResponse:response andError:&tokenError];
            if (!tokenError) {
                success(self.accessToken.token);
            } else {
                failure(tokenError);
            }
        }
        else {
            failure(error);
        }
    }];
    
    [sessionTask resume];
}

#pragma mark - Server response

- (NestAccessToken *)accessTokenFromServerData:(NSData *)data andResponse:(NSURLResponse *)response andError:(NSError **)error {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"AuthManager Token Response Status Code: %ld", (long)[httpResponse statusCode]);
    
    NSError *jsonParsingError;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&jsonParsingError];
    
    if (jsonParsingError) {
//        if (error) {
            *error = jsonParsingError;
//        }
    }
    
    long expiresIn = [[json objectForKey:@"expires_in"] longValue];
    NSString *accessTokenString = [json objectForKey:@"access_token"];
    
    return [NestAccessToken tokenWithTokenString:accessTokenString expiresIn:expiresIn];
}

@end
