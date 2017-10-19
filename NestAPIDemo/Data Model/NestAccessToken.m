//
//  NestAccessToken.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestAccessToken.h"

@interface NestAccessToken () <NSCoding>

@end

@implementation NestAccessToken

#pragma mark - Initialization

+ (NestAccessToken *)tokenWithTokenString:(NSString *)tokenString expiresIn:(long)seconds;
{
    NestAccessToken *accessToken = [[NestAccessToken alloc] init];
    accessToken.token = tokenString;
    accessToken.expiresOn = [[NSDate date] dateByAddingTimeInterval:seconds];
    return accessToken;
}

#pragma mark - Validation

- (BOOL)isValid {
    if (!self.token) {
        return NO;
    }

    if ([[NSDate date] compare:self.expiresOn] != NSOrderedAscending) {
        return NO;
    }

    return YES;
}

#pragma mark - Coding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.expiresOn forKey:@"expiresOn"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.token = [decoder decodeObjectForKey:@"token"];
        self.expiresOn = [decoder decodeObjectForKey:@"expiresOn"];
    }
    return self;
}

@end
