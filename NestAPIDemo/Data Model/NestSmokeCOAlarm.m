//
//  NestSmokeCOAlarm.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestSmokeCOAlarm.h"

@implementation NestSmokeCOAlarm

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.alarmId = dictionary[@"device_id"];
        self.name = dictionary[@"name"];
        self.batteryHealth = dictionary[@"temperature_scale"];
        
        self.isOnline = [dictionary[@"is_online"] boolValue];

        self.alarmState = [self alarmStateForStateString:dictionary[@"hvac_state"]];
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
