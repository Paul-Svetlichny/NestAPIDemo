//
//  Settings.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#ifndef Settings_h
#define Settings_h

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PSNestStructureAlarmStateOK,
    PSNestStructureAlarmStateWarning,
    PSNestStructureAlarmStateEmergency,
    PSNestStructureAlarmStateUndefined
} PSNestStructureAlarmState;

typedef enum : NSUInteger {
    PSNestThermostatHVACStateHeating,
    PSNestThermostatHVACStateCoolong,
    PSNestThermostatHVACStateOff,
    PSNestThermostatHVACStateUndefined
} PSNestThermostatHVACState;

extern NSString * const NestClientID;
extern NSString * const NestClientSecret;
extern NSString * const NestCurrentAPIDomain;
extern NSString * const NestState;
extern NSString * const RedirectURLString;
extern NSString * const NestAPIEndpoint;

#endif /* Settings_h */
