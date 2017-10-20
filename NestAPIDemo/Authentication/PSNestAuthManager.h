//
//  PSNestAuthManager.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSNestAuthManager : NSObject

- (void)authenticateWithAuthCode:(NSString *)authCode success:(void (^)(NSString *accessToken))success failure:(void (^)(NSError *error))failure;

@end
