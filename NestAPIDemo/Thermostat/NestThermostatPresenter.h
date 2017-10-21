//
//  NestThermostatPresenter.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/21/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NestThermostatPresenter : NSObject

- (instancetype)initWithThermostatId:(NSString *)thermostatId andPresentingViewController:(UIViewController *)presentingController;
- (void)showView;

@end
