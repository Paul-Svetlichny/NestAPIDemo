//
//  NestStructureViewController.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NestStructureViewController;

@protocol NestStructureViewControllerDelegate

- (void)nestStructureViewControllerDidSelectThermostatButton:(UIViewController *)controller;
- (void)nestStructureViewControllerDidSelectAlarmButton:(UIViewController *)controller;
- (void)nestStructureViewControllerDidSelectIndoorCamerasButton:(UIViewController *)controller;
- (void)nestStructureViewControllerDidSelectOutdoorCamerasButton:(UIViewController *)controller;
- (void)nestStructureViewDidAppear:(UIViewController *)controller;

@end

@interface NestStructureViewController : UIViewController

@property (weak, nonatomic) id <NestStructureViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *structureName;

@property (assign, nonatomic) int backgroundColour;

@property (assign, nonatomic) NSUInteger numberOfThermostats;
@property (assign, nonatomic) NSUInteger numberOfAlarms;
@property (assign, nonatomic) NSUInteger numberOfIndoorCameras;
@property (assign, nonatomic) NSUInteger numberOfOutdoorCameras;

@end
