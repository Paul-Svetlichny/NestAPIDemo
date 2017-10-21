//
//  NestThermostatViewController.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/21/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NestThermostatViewController;

@protocol NestThermostatViewControllerDelegate

- (void)nestThermostatViewController:(UIViewController *)controller didChangeTargetTemperatureToValue:(NSNumber *)value;
- (void)nestThermostatViewController:(UIViewController *)controller didSelectTemperatureScaleControlSegment:(NSUInteger)segment;

@end

@interface NestThermostatViewController : UIViewController

@property (weak, nonatomic) id <NestThermostatViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *temperatureScale;
@property (strong, nonatomic) NSString *hvacState;

@property (strong, nonatomic) NSString *ambientTemperature;
@property (strong, nonatomic) NSString *targetTemperature;
@property (strong, nonatomic) NSNumber *humidity;

@property (assign, nonatomic) BOOL hasFan;
@property (assign, nonatomic) BOOL canCool;
@property (assign, nonatomic) BOOL canHeat;
@property (assign, nonatomic) BOOL fanTimerActive;

@end
