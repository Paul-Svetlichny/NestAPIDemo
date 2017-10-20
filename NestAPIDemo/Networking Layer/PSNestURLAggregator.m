//
//  PSNestURLAggregator.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestURLAggregator.h"

@implementation PSNestURLAggregator

- (NSURL *)loginURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/login/oauth2?client_id=%@&state=%@", NestCurrentAPIDomain, NestClientID, NestState]];
}

- (NSURL *)authURLWithAuthCode:(NSString *)authCode {
    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://api.%@/oauth2/access_token?code=%@&client_id=%@&client_secret=%@&grant_type=authorization_code", NestCurrentAPIDomain, authCode, NestClientID, NestClientSecret]];
}

- (NSURL *)redirectURL {
    return [[NSURL alloc] initWithString:RedirectURLString];
}

@end
