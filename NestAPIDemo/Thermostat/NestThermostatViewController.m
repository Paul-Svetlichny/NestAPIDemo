//
//  NestThermostatViewController.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/21/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestThermostatViewController.h"

@interface NestThermostatViewController ()

@property (weak, nonatomic) IBOutlet UIView *temperatureView;
@property (weak, nonatomic) IBOutlet UILabel *ambientTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *temperatureScaleControl;
@property (weak, nonatomic) IBOutlet UISlider *targetTemperatureSlider;
@property (weak, nonatomic) IBOutlet UIView *hasFanView;
@property (weak, nonatomic) IBOutlet UIView *canHeatView;
@property (weak, nonatomic) IBOutlet UIView *canCoolView;
@property (weak, nonatomic) IBOutlet UIView *fanTimerActiveView;
@property (weak, nonatomic) IBOutlet UILabel *targetTemperatureSliderLabel;

@end

@implementation NestThermostatViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.temperatureView.layer.cornerRadius = self.temperatureView.frame.size.width/2;

    self.hasFanView.layer.cornerRadius = self.hasFanView.frame.size.width/2;
    self.hasFanView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.hasFanView.layer.borderWidth = 1;
    
    self.canHeatView.layer.cornerRadius = self.canHeatView.frame.size.width/2;
    self.canHeatView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.canHeatView.layer.borderWidth = 1;

    self.canCoolView.layer.cornerRadius = self.canCoolView.frame.size.width/2;
    self.canCoolView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.canCoolView.layer.borderWidth = 1;

    self.fanTimerActiveView.layer.cornerRadius = self.fanTimerActiveView.frame.size.width/2;
    self.fanTimerActiveView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.fanTimerActiveView.layer.borderWidth = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters

- (void)setName:(NSString *)name {
    _name = name;
    self.navigationItem.title = self.name;
}

-(void)setTemperatureScale:(NSString *)temperatureScale {
    _temperatureScale = temperatureScale;
    
    if ([self.temperatureScale isEqualToString:@"C"]) {
        [self.temperatureScaleControl setSelectedSegmentIndex:1];
        self.targetTemperatureSlider.minimumValue = 9;
        self.targetTemperatureSlider.maximumValue = 32;
    } else {
        [self.temperatureScaleControl setSelectedSegmentIndex:0];
        self.targetTemperatureSlider.minimumValue = 50;
        self.targetTemperatureSlider.maximumValue = 90;
    }
}

- (void)setAmbientTemperature:(NSString *)ambientTemperature {
    _ambientTemperature = ambientTemperature;
    self.ambientTemperatureLabel.text = [NSString stringWithFormat:@"%@°%@", self.ambientTemperature, self.temperatureScale];
}

- (void)setTargetTemperature:(NSString *)targetTemperature {
    _targetTemperature = targetTemperature;
    self.targetTemperatureLabel.text = [NSString stringWithFormat:@"Target: %@°%@", self.targetTemperature, self.temperatureScale];
    self.targetTemperatureSliderLabel.text = self.targetTemperature;
    self.targetTemperatureSlider.value = [self.targetTemperature floatValue];
}

- (void)setHumidity:(NSNumber *)humidity {
    _humidity = humidity;
    self.humidityLabel.text = [NSString stringWithFormat:@"%@", humidity];
}

- (void)setHasFan:(BOOL)hasFan {
    _hasFan = hasFan;
    if (self.hasFan) {
        self.hasFanView.backgroundColor = [UIColor greenColor];
    } else {
        self.hasFanView.backgroundColor = [UIColor redColor];
    }
}

- (void)setCanCool:(BOOL)canCool {
    _canCool = canCool;
    if (self.canCool) {
        self.canCoolView.backgroundColor = [UIColor greenColor];
    } else {
        self.canCoolView.backgroundColor = [UIColor redColor];
    }
}

- (void)setCanHeat:(BOOL)canHeat {
    _canHeat = canHeat;
    if (self.canHeat) {
       self.canHeatView.backgroundColor = [UIColor greenColor];
    } else {
        self.canHeatView.backgroundColor = [UIColor redColor];
    }
}

- (void)setFanTimerActive:(BOOL)fanTimerActive {
    _fanTimerActive = fanTimerActive;
    if (self.fanTimerActive) {
        self.fanTimerActiveView.backgroundColor = [UIColor greenColor];
    } else {
        self.fanTimerActiveView.backgroundColor = [UIColor redColor];
    }
}

- (void)setHvacState:(NSString *)hvacState {
    _hvacState = hvacState;
    if ([self.hvacState isEqualToString:@"heating"]) {
        self.temperatureView.backgroundColor = [UIColor orangeColor];
    } else if ([self.hvacState isEqualToString:@"cooling"]) {
        self.temperatureView.backgroundColor = [UIColor colorWithRed:0.647 green:0.949 blue:0.9529 alpha:1];
    } else {
        self.temperatureView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}

#pragma mark - Actions

- (IBAction)temepratureScaleControlerValueChanged:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    [self.delegate nestThermostatViewController:self didSelectTemperatureScaleControlSegment:control.selectedSegmentIndex];
}

- (IBAction)targetTemperatureSliderDragEnded:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float value = slider.value;
    
    if ([self.temperatureScale isEqualToString:@"C"]) {
        float rounded = value < 0.5f ? 0.5f : floorf(value * 2) / 2;
        [self.delegate nestThermostatViewController:self didChangeTargetTemperatureToValue:@(rounded)];
    } else {
        [self.delegate nestThermostatViewController:self didChangeTargetTemperatureToValue:@((int)value)];
    }
}

- (IBAction)targetTemperatureSlideValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float value = slider.value;
    
    if ([self.temperatureScale isEqualToString:@"C"]) {
        float rounded = value < 0.5f ? 0.5f : floorf(value * 2) / 2;
        self.targetTemperatureSliderLabel.text = [NSString stringWithFormat:@"%.01f", rounded];
    } else {
        self.targetTemperatureSliderLabel.text = [NSString stringWithFormat:@"%d", (int)value];
    }
}

@end
