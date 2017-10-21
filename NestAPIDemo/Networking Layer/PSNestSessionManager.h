//
//  PSNestSessionManager.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NestAccessToken.h"

@interface PSNestSessionManager : NSObject

@property (strong, nonatomic) NSURLSession *urlSession;
@property (strong, nonatomic) NSString *accessToken;

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;
- (void)setAccessTokenWithDictionary:(NSDictionary *)accessTokenDictionary;
- (BOOL)isValidSession;

@end
