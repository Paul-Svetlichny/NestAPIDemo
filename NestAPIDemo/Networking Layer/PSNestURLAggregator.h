//
//  PSNestURLAggregator.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSNestURLAggregator : NSObject

@property (strong, nonatomic) NSURL *redirectURL;

- (NSURL *)loginURL;
- (NSURL *)authURLWithAuthCode:(NSString *)authCode;

@end
