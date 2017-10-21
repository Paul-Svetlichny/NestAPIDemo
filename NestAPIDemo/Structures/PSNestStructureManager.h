//
//  PSNestStructureManager.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NestStructure;

@interface PSNestStructureManager : NSObject

- (void)nestStructureWithCallback:(void (^)(NestStructure *structure, NSError *error))callback;

@end
