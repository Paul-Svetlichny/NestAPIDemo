//
//  NestAuthWebViewController.h
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NestAuthViewController;

@protocol NestAuthViewControllerDelegate

- (void)nestAuthViewController:(NestAuthViewController *)authController didRecieveServerResponceURL:(NSURL *)responseURL;

@end

@interface NestAuthViewController : UIViewController

@property (weak, nonatomic) id <NestAuthViewControllerDelegate> delegate;
@property (strong, nonatomic) NSURLRequest *request;

@end
