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
        self.thermostatId = thermostatId;
        self.presentingController = presentingController;
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
    if (self.presentingController.navigationController) {
        [self.presentingController.navigationController pushViewController:self.thermostatController animated:YES];
        [self loadThermostatWithId:self.thermostatId];
    }
}

- (void)loadThermostatWithId:(NSString *)thermostatId {
    [self.thermostatManager nestThermostatWithThermostatId:self.thermostatId andCallback:^(NestThermostat *thermostat, NSError *error) {
        [self displayThermostat:thermostat];
    }];
}

#pragma mark - Displaying properties

- (void)displayThermostat:(NestThermostat *)thermostat {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.thermostat = thermostat;
        
        [self displayTemperatureScale:self.thermostat.temperatureScale];
        
        [self displayThermostatName:self.thermostat.name];
        
        [self displayHumidity:self.thermostat.humidity];
        
        [self displayHVACSate:self.thermostat.hvacState];
        
        if ([self.thermostat.temperatureScale isEqualToString:@"C"]) {
            [self displayAmbientTemperature:self.thermostat.ambientTemperatureC];
            
            [self displayTargetTemperature:self.thermostat.targetTemperatureC];
        } else {
            [self displayAmbientTemperature:self.thermostat.ambientTemperatureF];
            
            [self displayTargetTemperature:self.thermostat.targetTemperatureF];
        }
        
        [self displayCanCool:self.thermostat.canCool];
        
        [self displayHasFan:self.thermostat.hasFan];
        
        [self displayCanHeat:self.thermostat.canHeat];
        
        [self displayFanTimerActive:self.thermostat.fanTimerActive];
    });
}

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
        [self displayTargetTemperature:self.thermostat.targetTemperatureF];
        [self displayAmbientTemperature:self.thermostat.ambientTemperatureF];
    } else {
        temperatureScale = @"C";
        [self displayTemperatureScale:temperatureScale];
        [self displayTargetTemperature:self.thermostat.targetTemperatureC];
        [self displayAmbientTemperature:self.thermostat.ambientTemperatureC];
    }

    __weak NestThermostatPresenter *weakself = self;

    [self.thermostatManager setTemperatureScale:temperatureScale forThermostsatWithId:self.thermostatId withCallback:^(NSString *temperatureScale) {
        weakself.thermostat.temperatureScale = temperatureScale;
    }];
}

- (void)nestThermostatViewController:(UIViewController *)controller didChangeTargetTemperatureToValue:(NSNumber *)value {
    __weak id weakself = self;
    [self.thermostatManager setTargetTemperature:value forTemperatureScale:self.thermostat.temperatureScale forThermostsatWithId:self.thermostat.thermostatId withCallback:^(NSNumber *targetTemperature) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself displayTargetTemperature:targetTemperature];
        });
    }];
}

@end
