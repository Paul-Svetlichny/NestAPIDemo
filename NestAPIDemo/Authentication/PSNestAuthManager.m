//
//  PSNestAuthManager.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestAuthManager.h"
#import "NestAccessToken.h"
#import "Settings.h"

@interface PSNestAuthManager () <NSURLSessionDelegate>

@property (strong, nonatomic) NSURLSession *urlSession;

@end

@implementation PSNestAuthManager

+ (PSNestAuthManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static PSNestAuthManager *sharedManager = nil;

    dispatch_once(&onceToken, ^{
        sharedManager = [[PSNestAuthManager alloc] init];
    });
    
    return sharedManager;
}

- (NSURLSession *)urlSession
{
    if (!_urlSession)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        sessionConfiguration.timeoutIntervalForRequest = 30;
        sessionConfiguration.timeoutIntervalForResource = 45;
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        _urlSession = urlSession;
    }
    
    return _urlSession;
}

- (void)authenticateWithAuthCode:(NSString *)authCode success:(void (^)(NSString *accessToken))success failure:(void (^)(NSError *error))failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSURL *requestURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://api.%@/oauth2/access_token?code=%@&client_id=%@&client_secret=%@&grant_type=authorization_code", NestCurrentAPIDomain, authCode, NestClientID, NestClientSecret]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = @"application/x-www-form-urlencoded";
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];

    NSURLSessionTask *sessionTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"AuthManager Token Response Status Code: %ld", (long)[httpResponse statusCode]);
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        
        long expiresIn = [[json objectForKey:@"expires_in"] longValue];
        NSString *accessTokenString = [json objectForKey:@"access_token"];
        
        NestAccessToken *accessToken = [NestAccessToken tokenWithTokenString:accessTokenString expiresIn:expiresIn];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    [sessionTask resume];

}

- (void)authenticationRequestCompletedWithAuthCode:(NSString *)authCode {
    if (!authCode) {
        return;
    }
}

@end
