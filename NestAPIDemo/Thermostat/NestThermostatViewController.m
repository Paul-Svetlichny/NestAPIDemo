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
    
    _temperatureView.layer.cornerRadius = _temperatureView.frame.size.width/2;

    _hasFanView.layer.cornerRadius = _hasFanView.frame.size.width/2;
    _hasFanView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _hasFanView.layer.borderWidth = 1;
    
    _canHeatView.layer.cornerRadius = _canHeatView.frame.size.width/2;
    _canHeatView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _canHeatView.layer.borderWidth = 1;

    _canCoolView.layer.cornerRadius = _canCoolView.frame.size.width/2;
    _canCoolView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _canCoolView.layer.borderWidth = 1;

    _fanTimerActiveView.layer.cornerRadius = _fanTimerActiveView.frame.size.width/2;
    _fanTimerActiveView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _fanTimerActiveView.layer.borderWidth = 1;
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
    self.navigationItem.title = _name;
}

-(void)setTemperatureScale:(NSString *)temperatureScale {
    _temperatureScale = temperatureScale;
    
    if ([_temperatureScale isEqualToString:@"C"]) {
        [_temperatureScaleControl setSelectedSegmentIndex:1];
        _targetTemperatureSlider.minimumValue = 9;
        _targetTemperatureSlider.maximumValue = 32;
    } else {
        [_temperatureScaleControl setSelectedSegmentIndex:0];
        _targetTemperatureSlider.minimumValue = 50;
        _targetTemperatureSlider.maximumValue = 90;
    }
}

- (void)setAmbientTemperature:(NSString *)ambientTemperature {
    _ambientTemperature = ambientTemperature;
    _ambientTemperatureLabel.text = [NSString stringWithFormat:@"%@°%@", _ambientTemperature, _temperatureScale];
}

- (void)setTargetTemperature:(NSString *)targetTemperature {
    _targetTemperature = targetTemperature;
    _targetTemperatureLabel.text = [NSString stringWithFormat:@"Target: %@°%@", _targetTemperature, _temperatureScale];
    _targetTemperatureSliderLabel.text = _targetTemperature;
    _targetTemperatureSlider.value = [_targetTemperature floatValue];
}

- (void)setHumidity:(NSNumber *)humidity {
    _humidity = humidity;
    _humidityLabel.text = [NSString stringWithFormat:@"%@", humidity];
}

- (void)setHasFan:(BOOL)hasFan {
    _hasFan = hasFan;
    if (_hasFan) {
        _hasFanView.backgroundColor = [UIColor greenColor];
    } else {
        _hasFanView.backgroundColor = [UIColor redColor];
    }
}

- (void)setCanCool:(BOOL)canCool {
    _canCool = canCool;
    if (_canCool) {
        _canCoolView.backgroundColor = [UIColor greenColor];
    } else {
        _canCoolView.backgroundColor = [UIColor redColor];
    }
}

- (void)setCanHeat:(BOOL)canHeat {
    _canHeat = canHeat;
    if (_canHeat) {
       _canHeatView.backgroundColor = [UIColor greenColor];
    } else {
        _canHeatView.backgroundColor = [UIColor redColor];
    }
}

- (void)setFanTimerActive:(BOOL)fanTimerActive {
    _fanTimerActive = fanTimerActive;
    if (_fanTimerActive) {
        _fanTimerActiveView.backgroundColor = [UIColor greenColor];
    } else {
        _fanTimerActiveView.backgroundColor = [UIColor redColor];
    }
}

- (void)setHvacState:(NSString *)hvacState {
    _hvacState = hvacState;
    if ([_hvacState isEqualToString:@"heating"]) {
        _temperatureView.backgroundColor = [UIColor orangeColor];
    } else if ([_hvacState isEqualToString:@"cooling"]) {
        _temperatureView.backgroundColor = [UIColor colorWithRed:0.647 green:0.949 blue:0.9529 alpha:1];
    } else {
        _temperatureView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}

#pragma mark - Actions

- (IBAction)temepratureScaleControlerValueChanged:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    [_delegate nestThermostatViewController:self didSelectTemperatureScaleControlSegment:control.selectedSegmentIndex];
}

- (IBAction)targetTemperatureSliderDragEnded:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float value = slider.value;
    
    if ([_temperatureScale isEqualToString:@"C"]) {
        float rounded = value < 0.5f ? 0.5f : floorf(value * 2) / 2;
        [_delegate nestThermostatViewController:self didChangeTargetTemperatureToValue:@(rounded)];
    } else {
        [_delegate nestThermostatViewController:self didChangeTargetTemperatureToValue:@((int)value)];
    }
}

- (IBAction)targetTemperatureSlideValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float value = slider.value;
    
    if ([_temperatureScale isEqualToString:@"C"]) {
        float rounded = value < 0.5f ? 0.5f : floorf(value * 2) / 2;
        _targetTemperatureSliderLabel.text = [NSString stringWithFormat:@"%.01f", rounded];
    } else {
        _targetTemperatureSliderLabel.text = [NSString stringWithFormat:@"%d", (int)value];
    }
}

@end
