//
//  PSViewController.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/29/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSViewController.h"

@interface PSViewController ()

@end

@implementation PSViewController

- (void)showNetworkActivityIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
}

- (void)hideNetworkActivityIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
}

@end
