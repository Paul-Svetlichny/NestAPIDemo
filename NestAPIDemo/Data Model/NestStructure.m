//
//  NestStructure.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestStructure.h"

@implementation NestStructure

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.structureId = dictionary[@"structure_id"];
        self.name = dictionary[@"name"];
        self.coAlarmState = [self alarmStateForStateString:dictionary[@"co_alarm_state"]];
        self.smokeAlarmState = [self alarmStateForStateString:dictionary[@"smoke_alarm_state"]];

        self.thermostats = [[NSMutableArray alloc] initWithArray:dictionary[@"thermostats"]];
        self.smokeCOAlarms = [[NSMutableArray alloc] initWithArray:dictionary[@"smoke_co_alarms"]];
        self.cameras = [[NSMutableArray alloc] initWithArray:dictionary[@"cameras"]];
    }
    
    return self;
}

- (PSNestStructureAlarmState)alarmStateForStateString:(NSString *)state {
    if ([state isEqualToString:@"ok"]) {
        return PSNestStructureAlarmStateOK;
    }
    
    if ([state isEqualToString:@"warning"]) {
        return PSNestStructureAlarmStateWarning;
    }
    
    if ([state isEqualToString:@"emergency"]) {
        return PSNestStructureAlarmStateEmergency;
    }
    
    return PSNestStructureAlarmStateUndefined;
}

@end
