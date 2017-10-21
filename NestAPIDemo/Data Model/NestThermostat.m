//
//  NestThermostat.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestThermostat.h"

@implementation NestThermostat

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.thermostatId = dictionary[@"device_id"];
        self.name = dictionary[@"name"];
//        self.hvacState = [self hvacStateForStateString:dictionary[@"hvac_state"]];
        self.hvacState = dictionary[@"hvac_state"];
        self.temperatureScale = dictionary[@"temperature_scale"];
        
        self.ambientTemperatureF = dictionary[@"ambient_temperature_f"];
        self.targetTemperatureF = dictionary[@"target_temperature_f"];
        self.ambientTemperatureC = dictionary[@"ambient_temperature_c"];
        self.targetTemperatureC = dictionary[@"target_temperature_c"];
        self.humidity = dictionary[@"humidity"];

        self.hasFan = [dictionary[@"has_fan"] boolValue];
        self.canCool = [dictionary[@"can_cool"] boolValue];
        self.canHeat = [dictionary[@"can_heat"] boolValue];
        self.fanTimerActive = [dictionary[@"fan_timer_active"] boolValue];
    }
    
    return self;
}
/*
- (PSNestThermostatHVACState)hvacStateForStateString:(NSString *)state {
    if ([state isEqualToString:@"heating"]) {
        return PSNestThermostatHVACStateHeating;
    }
    
    if ([state isEqualToString:@"cooling"]) {
        return PSNestThermostatHVACStateCoolong;
    }
    
    if ([state isEqualToString:@"off"]) {
        return PSNestThermostatHVACStateOff;
    }
    
    return PSNestThermostatHVACStateUndefined;
}
*/
@end
