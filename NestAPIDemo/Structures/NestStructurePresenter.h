//
//  NestStructurePresenter.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NestStructurePresenter : NSObject

- (instancetype)initWithPresentingViewController:(UIViewController *)presentingController;
- (void)showView;

@end
