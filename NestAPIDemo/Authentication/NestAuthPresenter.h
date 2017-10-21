//
//  NestAuthPresenter.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NestAuthPresenter : NSObject

@property (strong, nonatomic, readonly) UIViewController *presentingController;

- (instancetype)initWithPresentingViewController:(UIViewController *)presentingController;

- (void)showView;

@end
