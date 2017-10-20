//
//  NestStructure.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NestStructure : NSObject

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) PSNestStructureAlarmState coAlarmState;
@property (assign, nonatomic) PSNestStructureAlarmState smokeAlarmState;

@property (strong, nonatomic) NSMutableArray *thermostats;
@property (strong, nonatomic) NSMutableArray *smokeCOAlarms;
@property (strong, nonatomic) NSMutableArray *cameras;

@end
