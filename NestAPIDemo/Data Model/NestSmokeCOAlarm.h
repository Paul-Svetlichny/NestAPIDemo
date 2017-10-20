//
//  NestSmokeCOAlarm.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NestSmokeCOAlarm : NSObject

@property (strong, nonatomic) NSString *alarmId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *batteryHealth;

@property (assign, nonatomic) PSNestStructureAlarmState alarmState;

@end
