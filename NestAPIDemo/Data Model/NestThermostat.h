//
//  NestThermostat.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NestThermostat : NSObject

@property (strong, nonatomic) NSString *thermostatId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *hvacMode;
@property (strong, nonatomic) NSString *humidity;
@property (strong, nonatomic) NSString *temperatureScale;

@property (strong, nonatomic) NSNumber *ambientTemperatureF;
@property (strong, nonatomic) NSNumber *targetTemperatureF;
@property (strong, nonatomic) NSNumber *ambientTemperatureC;
@property (strong, nonatomic) NSNumber *targetTemperatureC;

@property (assign, nonatomic) BOOL hasFan;
@property (assign, nonatomic) BOOL canCool;
@property (assign, nonatomic) BOOL canHeat;
@property (assign, nonatomic) BOOL fanTimerActive;

@end
