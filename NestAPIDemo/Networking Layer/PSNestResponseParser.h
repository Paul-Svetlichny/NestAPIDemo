//
//  PSNestResponseParser.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSNestResponseParser : NSObject

- (NSDictionary *)responseDictionaryFromResponseData:(NSData *)data;
- (NSString *)authCodeFromResponse:(NSURL *)responseURL;

@end
