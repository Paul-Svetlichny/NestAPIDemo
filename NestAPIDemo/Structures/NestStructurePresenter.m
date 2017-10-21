//
//  NestStructurePresenter.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestStructurePresenter.h"
#import "NestStructureViewController.h"
#import "PSNestStructureManager.h"
#import "NestThermostatPresenter.h"

#import "PSNestRequestBuilder.h"
#import "PSNestResponseParser.h"

#import "NestStructure.h"

@interface NestStructurePresenter () <NestStructureViewControllerDelegate>

@property (strong, nonatomic) UIViewController *presentingController;
@property (strong, nonatomic) NestStructureViewController *structureController;
@property (strong, nonatomic) PSNestStructureManager *structureManager;
@property (strong, nonatomic) NestThermostatPresenter *thermostatPresenter;

@property (strong, nonatomic) NestStructure *structure;

@end

@implementation NestStructurePresenter

- (instancetype)initWithPresentingViewController:(UIViewController *)presentingController {
    if (self = [super init]) {
        _presentingController = presentingController;
    }
    
    return self;
}

- (PSNestStructureManager *)structureManager {
    if (!_structureManager) {
        _structureManager = [[PSNestStructureManager alloc] init];
    }
    
    return _structureManager;
}

- (NestStructureViewController *)structureController {
    if (!_structureController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Structure" bundle:nil];
        _structureController = (NestStructureViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NestStructureViewController"];
        
        _structureController.delegate = self;
    }
    
    return _structureController;
}

- (void)showView {
    if (_presentingController.navigationController) {
        _presentingController.navigationController.viewControllers = @[self.structureController];
    }
}

- (void)loadStructure {
    [self.structureManager nestStructureWithCallback:^(NestStructure *structure, NSError *error) {
        _structure = structure;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayStructureName:_structure.name];
            
            [self displayNumberOfThermostats:_structure.thermostats.count];
            
            [self displayNumberOfAlarms:_structure.smokeCOAlarms.count];
            
            //        There is no camera support in this demo
            [self displayNumberOfIndoorCams:0];
            
            //        There is no camera support in this demo
            [self displayNumberOfOutdoorCams:0];
            
            [self displaySmokeAlarmState:_structure.smokeAlarmState];
        });
    }];
}

- (void)displayStructureName:(NSString *)name {
    self.structureController.structureName = name;
}

- (void)displayNumberOfThermostats:(NSUInteger)numberOfThermostats {
    self.structureController.numberOfThermostats = numberOfThermostats;
}

- (void)displayNumberOfAlarms:(NSUInteger)numberOfAlarms {
    self.structureController.numberOfAlarms = numberOfAlarms;
}

- (void)displayNumberOfIndoorCams:(NSUInteger)numberOfIndoorCams {
    self.structureController.numberOfIndoorCameras = numberOfIndoorCams;
}

- (void)displayNumberOfOutdoorCams:(NSUInteger)numberOfOutdoorCams {
    self.structureController.numberOfOutdoorCameras = numberOfOutdoorCams;
}

- (void)displaySmokeAlarmState:(PSNestStructureAlarmState)alarmState {
    switch (alarmState) {
        case PSNestStructureAlarmStateOK:
        {
            self.structureController.backgroundColour = 0xFFFFFF;
        }
            break;
        case PSNestStructureAlarmStateWarning:
        {
            self.structureController.backgroundColour = 0xFFA500;
        }
            break;
        case PSNestStructureAlarmStateEmergency:
        {
            self.structureController.backgroundColour = 0xFF0000;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Nest Structure View Controller Delegate

- (void)nestStructureViewDidAppear:(UIViewController *)controller {
    [self loadStructure];
}

- (void)nestStructureViewControllerDidSelectThermostatButton:(UIViewController *)controller {
    NSString *thermostatId = _structure.thermostats[0];
    _thermostatPresenter = [[NestThermostatPresenter alloc] initWithThermostatId:thermostatId andPresentingViewController:self.structureController];
    [_thermostatPresenter showView];
}

- (void)nestStructureViewControllerDidSelectAlarmButton:(UIViewController *)controller {
    
}

- (void)nestStructureViewControllerDidSelectIndoorCamerasButton:(UIViewController *)controller {
    
}

- (void)nestStructureViewControllerDidSelectOutdoorCamerasButton:(UIViewController *)controller {
    
}

@end
