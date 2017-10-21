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
@property (strong, nonatomic) NSString *temperatureScale;

@property (strong, nonatomic) NSNumber *ambientTemperatureF;
@property (strong, nonatomic) NSNumber *targetTemperatureF;
@property (strong, nonatomic) NSNumber *ambientTemperatureC;
@property (strong, nonatomic) NSNumber *targetTemperatureC;
@property (strong, nonatomic) NSNumber *humidity;

@property (assign, nonatomic) BOOL hasFan;
@property (assign, nonatomic) BOOL canCool;
@property (assign, nonatomic) BOOL canHeat;
@property (assign, nonatomic) BOOL fanTimerActive;

@property (assign, nonatomic) PSNestThermostatHVACState hvacState;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
