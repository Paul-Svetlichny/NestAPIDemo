//
//  NestAccessToken.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NestAccessToken : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSDate *expiresOn;

+ (NestAccessToken *)tokenWithTokenString:(NSString *)tokenString expiresIn:(long)seconds;

@end
