//
//  NestThermostatPresenter.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/21/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestThermostatPresenter.h"
#import "NestThermostatViewController.h"
#import "PSNestThermostatManager.h"
#import "NestThermostat.h"

@interface NestThermostatPresenter () <NestThermostatViewControllerDelegate>

@property (strong, nonatomic) UIViewController *presentingController;
@property (strong, nonatomic) NestThermostatViewController *thermostatController;
@property (strong, nonatomic) PSNestThermostatManager *thermostatManager;

@property (strong, nonatomic) NSString *thermostatId;
@property (strong, nonatomic) NestThermostat *thermostat;

@end

@implementation NestThermostatPresenter

- (instancetype)initWithThermostatId:(NSString *)thermostatId andPresentingViewController:(UIViewController *)presentingController {
    if (self = [super init]) {
        _thermostatId = thermostatId;
        _presentingController = presentingController;
    }
    
    return self;
}

- (PSNestThermostatManager *)thermostatManager {
    if (!_thermostatManager) {
        _thermostatManager = [[PSNestThermostatManager alloc] init];
    }
    
    return _thermostatManager;
}

- (NestThermostatViewController *)thermostatController {
    if (!_thermostatController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Thermostat" bundle:nil];
        _thermostatController = (NestThermostatViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NestThermostatViewController"];
        
        _thermostatController.delegate = self;
    }
    
    return _thermostatController;
}

- (void)showView {
    if (_presentingController.navigationController) {
        [_presentingController.navigationController pushViewController:self.thermostatController animated:YES];
        [self loadThermostatWithId:_thermostatId];
    }
}

- (void)loadThermostatWithId:(NSString *)thermostatId {
    [self.thermostatManager nestThermostatWithThermostatId:_thermostatId andCallback:^(NestThermostat *thermostat, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _thermostat = thermostat;
            
            [self displayTemperatureScale:_thermostat.temperatureScale];
            
            [self displayThermostatName:_thermostat.name];
            
            [self displayHumidity:_thermostat.humidity];

            [self displayHVACSate:_thermostat.hvacState];
            
            if ([_thermostat.temperatureScale isEqualToString:@"C"]) {
                [self displayAmbientTemperature:_thermostat.ambientTemperatureC];
                
                [self displayTargetTemperature:_thermostat.targetTemperatureC];
            } else {
                [self displayAmbientTemperature:_thermostat.ambientTemperatureF];
                
                [self displayTargetTemperature:_thermostat.targetTemperatureF];
            }
            
            [self displayCanCool:_thermostat.canCool];
            
            [self displayHasFan:_thermostat.hasFan];
            
            [self displayCanHeat:_thermostat.canHeat];
            
            [self displayFanTimerActive:_thermostat.fanTimerActive];
        });
    }];
}

#pragma mark - Displaying properties

- (void)displayThermostatName:(NSString *)name {
    self.thermostatController.name = name;
}

- (void)displayHVACSate:(NSString *)state {
    self.thermostatController.hvacState = state;
}

- (void)displayHumidity:(NSNumber *)humidity {
    self.thermostatController.humidity = humidity;
}

- (void)displayTemperatureScale:(NSString *)temperatureScale {
    self.thermostatController.temperatureScale = temperatureScale;
}

- (void)displayAmbientTemperature:(NSNumber *)temperature {
    self.thermostatController.ambientTemperature = [NSString stringWithFormat:@"%@", temperature];
}

- (void)displayTargetTemperature:(NSNumber *)temperature {
    self.thermostatController.targetTemperature = [NSString stringWithFormat:@"%@", temperature];
}

- (void)displayCanCool:(BOOL)canCool {
    self.thermostatController.canCool = canCool;
}

- (void)displayCanHeat:(BOOL)canHeat {
    self.thermostatController.canHeat = canHeat;
}

- (void)displayHasFan:(BOOL)hasFan {
    self.thermostatController.hasFan = hasFan;
}

- (void)displayFanTimerActive:(BOOL)fanTimerActive {
    self.thermostatController.fanTimerActive = fanTimerActive;
}

#pragma mark - View Delegates

- (void)nestThermostatViewController:(UIViewController *)controller didSelectTemperatureScaleControlSegment:(NSUInteger)segment {
    NSString *temperatureScale;
    if (segment == 0) {
        temperatureScale = @"F";
        [self displayTemperatureScale:temperatureScale];
        [self displayTargetTemperature:_thermostat.targetTemperatureF];
        [self displayAmbientTemperature:_thermostat.ambientTemperatureF];
    } else {
        temperatureScale = @"C";
        [self displayTemperatureScale:temperatureScale];
        [self displayTargetTemperature:_thermostat.targetTemperatureC];
        [self displayAmbientTemperature:_thermostat.ambientTemperatureC];
    }

    [self.thermostatManager setTemperatureScale:temperatureScale forThermostsatWithId:_thermostatId withCallback:^(NSString *temperatureScale) {
    }];
}

- (void)nestThermostatViewController:(UIViewController *)controller didChangeTargetTemperatureToValue:(NSNumber *)value {
    __weak id weakself = self;
    [self.thermostatManager setTargetTemperature:value forTemperatureScale:_thermostat.temperatureScale forThermostsatWithId:_thermostat.thermostatId withCallback:^(NSNumber *targetTemperature) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself displayTargetTemperature:targetTemperature];
        });
    }];
}

@end
