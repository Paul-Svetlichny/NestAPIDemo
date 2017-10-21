//
//  NestAuthPresenter.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "NestAuthPresenter.h"
#import "PSNestAuthManager.h"
#import "PSNestRequestBuilder.h"
#import "PSNestResponseParser.h"
#import "NestAuthViewController.h"
#import "NestStructurePresenter.h"

#import "PSNestAPIManager.h"
#import "PSNestSessionManager.h"

@interface NestAuthPresenter () <NestAuthViewControllerDelegate>

@property (strong, nonatomic) NestAuthViewController *authController;
@property (strong, nonatomic) PSNestAuthManager *authManager;
@property (strong, nonatomic) UIViewController *presentingController;

@end

@implementation NestAuthPresenter

- (instancetype)initWithPresentingViewController:(UIViewController *)presentingController {
    if (self = [super init]) {
        _presentingController = presentingController;
    }
    
    return self;
}

- (PSNestAuthManager *)authManager {
    if (!_authManager) {
        _authManager = [[PSNestAuthManager alloc] init];
    }
    
    return _authManager;
}

- (NestAuthViewController *)authController {
    if (!_authController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
        _authController = (NestAuthViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NestAuthViewController"];
        
        PSNestRequestBuilder *nestRequestBuilder = [[PSNestRequestBuilder alloc] init];
        _authController.request = [nestRequestBuilder loginRequest];
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
        [self.presentingController dismissViewControllerAnimated:YES completion:^{
            NestStructurePresenter *structurePresenter = [[NestStructurePresenter alloc] initWithPresentingViewController:_presentingController];
            [structurePresenter showView];
        }];

        NSLog(@"access token: %@", accessToken);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Nest Auth View Controller Delegate

- (void)nestAuthViewController:(NestAuthViewController *)authController didRecieveServerResponceURL:(NSURL *)responseURL {
    PSNestResponseParser *responseParser = [[PSNestResponseParser alloc] init];
    
    NSString *authCode = [responseParser authCodeFromResponse:responseURL];
    
    if (authCode) {
        [self authenticateWithAuthCode:authCode];
    }
}


@end
