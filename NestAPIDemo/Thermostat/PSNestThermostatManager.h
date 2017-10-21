//
//  PSNestThermostatManager.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/21/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NestThermostat;

@interface PSNestThermostatManager : NSObject

- (void)nestThermostatWithThermostatId:(NSString *)thermostatId andCallback:(void (^)(NestThermostat *thermostat, NSError *error))callback;
- (void)setTargetTemperature:(NSNumber *)targetTemperature forTemperatureScale:(NSString *)scale forThermostsatWithId:(NSString *)thermostatId withCallback:(void (^)(NSNumber *targetTemperature))callback;
- (void)setTemperatureScale:(NSString *)scale forThermostsatWithId:(NSString *)thermostatId withCallback:(void (^)(NSString *temperatureScale))callback;

@end
