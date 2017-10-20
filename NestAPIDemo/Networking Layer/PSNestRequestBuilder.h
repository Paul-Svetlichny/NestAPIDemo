//
//  PSNestRequestBuilder.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSNestRequestBuilder : NSObject

- (NSMutableURLRequest *)authenticationRequestWithAuthCode:(NSString *)authCode;
- (NSURLRequest *)loginRequest;

- (NSMutableURLRequest *)requestForBaseURLString:(NSString *)baseURLString
                                         andPath:(NSString *)path
                                andRequestMethod:(NSString *)requestMethod
                                        withData:(NSData *)data
                                  andAccessToken:(NSString *)accessToken;


@end
