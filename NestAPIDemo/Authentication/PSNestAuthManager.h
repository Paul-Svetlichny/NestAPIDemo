//
//  PSNestAuthManager.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NestAccessToken.h"

@interface PSNestAuthManager : NSObject

+ (PSNestAuthManager *)sharedInstance;

@property (strong, nonatomic) NSString *authCode;
@property (strong, nonatomic) NestAccessToken *accessToken;

- (void)authenticateWithAuthCode:(NSString *)authCode success:(void (^)(NSString *accessToken))success failure:(void (^)(NSError *error))failure;

@end
