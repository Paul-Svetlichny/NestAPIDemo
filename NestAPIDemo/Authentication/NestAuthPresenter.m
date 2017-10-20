//
//  NestAuthPresenter.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestAuthPresenter.h"
#import "PSNestAuthManager.h"
#import "NestAuthViewController.h"
#import "Settings.h"

@interface NestAuthPresenter () <NestAuthViewControllerDelegate>

@property (strong, nonatomic) NestAuthViewController *authController;
@property (strong, nonatomic) PSNestAuthManager *authManager;

@end

@implementation NestAuthPresenter

- (instancetype)initWithPresentingViewController:(UIViewController *)presentingController {
    if (self = [super init]) {
        _presentingController = presentingController;
    }
    
    return self;
}

- (PSNestAuthManager *)authManager {
    return [PSNestAuthManager sharedInstance];
}

- (NestAuthViewController *)authController {
    if (!_authController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
        _authController = (NestAuthViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NestAuthViewController"];
        
        _authController.request = self.authManager.loginRequest;
        _authController.delegate = self;
    }
    
    return _authController;
}

- (void)showView {
    [_presentingController presentViewController:self.authController animated:YES completion:nil];
}

#pragma mark - Authentication

- (void)authenticateWithAuthCode:(NSString *)authCode {
    [self.authManager authenticateWithAuthCode:authCode success:^(NSString *accessToken) {
        NSLog(@"access token: %@", accessToken);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Nest Auth View Controller Delegate

- (void)nestAuthViewController:(NestAuthViewController *)authController didRecieveServerResponceURL:(NSURL *)responseURL {
    NSURL *redirectURL = [[NSURL alloc] initWithString:RedirectURL];
    
    if ([[responseURL host] isEqualToString:[redirectURL host]]) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:responseURL
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSString *authCode = [self valueForKey:@"code" fromQueryItems:queryItems];

        [self authenticateWithAuthCode:authCode];
        
        [self.presentingController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

@end
