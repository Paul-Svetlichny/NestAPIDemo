//
//  NestStructureViewController.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestStructureViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface NestStructureViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *structureNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *structureImageView;

@end

@implementation NestStructureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Setters

- (void)setStructureName:(NSString *)structureName {
    _structureName = structureName;
    _structureNameLabel.text = _structureName;
    if (![_structureName isEqualToString:@"Casa Del Max"]) {
        _structureImageView.image = [UIImage imageNamed:@"house"];
    }
}

- (void)setBackgroundColour:(int)backgroundColour {
    _backgroundColour = backgroundColour;
    [self.view setBackgroundColor:UIColorFromRGB(backgroundColour)];
}

- (void)setNumberOfAlarms:(NSUInteger)numberOfAlarms {
    _numberOfAlarms = numberOfAlarms;
    [self.collectionView reloadData];
}

- (void)setNumberOfIndoorCameras:(NSUInteger)numberOfIndoorCameras {
    _numberOfIndoorCameras = numberOfIndoorCameras;
    [self.collectionView reloadData];
}

- (void)setNumberOfOutdoorCameras:(NSUInteger)numberOfOutdoorCameras {
    _numberOfOutdoorCameras = numberOfOutdoorCameras;
    [self.collectionView reloadData];
}

- (void)setNumberOfThermostats:(NSUInteger)numberOfThermostats {
    _numberOfThermostats = numberOfThermostats;
    [self.collectionView reloadData];
}

#pragma mark - Collection View Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"structureCell" forIndexPath:indexPath];
    
    [self configureCell:cell forItemAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger numberOfItems;
    NSString *title;
    
    switch (indexPath.row) {
        case 0:
        {
            numberOfItems = _numberOfThermostats;
            title = @"Thermostats";
        }
            break;
        case 1:
        {
            numberOfItems = _numberOfAlarms;
            title = @"Smoke + CO Alarms";
        }
            break;
        case 2:
        {
            numberOfItems = _numberOfIndoorCameras;
            title = @"Indoor Cams";
        }
            break;
        case 3:
        {
            numberOfItems = _numberOfOutdoorCameras;
            title = @"Outdoor Cams";
        }
            break;
        default:
        {
            numberOfItems = 0;
            title = @"Undefined";
        }
            break;
    }
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:10];
    imageView.image = [UIImage imageNamed:title];

    UILabel *nameLabel = (UILabel *)[cell viewWithTag:11];
    nameLabel.text = [NSString stringWithFormat:@"%@: %lu", title, (unsigned long)numberOfItems];
    
    UIView *coverView = (UIView *)[cell viewWithTag:12];
    if (numberOfItems > 0) {
        coverView.alpha = 0;
    } else {
        coverView.alpha = 0.4;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            [_delegate nestStructureViewControllerDidSelectThermostatButton:self];
        }
            break;
        case 1:
        {
            [_delegate nestStructureViewControllerDidSelectAlarmButton:self];
        }
            break;
        case 2:
        {
            [_delegate nestStructureViewControllerDidSelectIndoorCamerasButton:self];
        }
            break;
        case 3:
        {
            [_delegate nestStructureViewControllerDidSelectOutdoorCamerasButton:self];
        }
            break;
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
