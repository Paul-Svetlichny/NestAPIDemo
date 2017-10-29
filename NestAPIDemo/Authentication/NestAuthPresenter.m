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

@property (strong, nonatomic, readwrite) UIViewController *presentingController;

@property (strong, nonatomic) NestAuthViewController *authViewController;
@property (strong, nonatomic) PSNestAuthManager *authManager;
@property (strong, nonatomic) NestStructurePresenter *structurePresenter;

@property (strong, nonatomic) PSNestRequestBuilder *nestRequestBuilder;

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

- (PSNestRequestBuilder *)nestRequestBuilder {
    if (!_nestRequestBuilder) {
        _nestRequestBuilder = [[PSNestRequestBuilder alloc] init];
    }
    
    return _nestRequestBuilder;
}

- (NestAuthViewController *)authViewController {
    if (!_authViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
        _authViewController = (NestAuthViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NestAuthViewController"];
        
        _authViewController.request = [self.nestRequestBuilder loginRequest];
        _authViewController.delegate = self;
    }
    
    return _authViewController;
}

- (void)showView {
    [self.presentingController presentViewController:self.authViewController animated:YES completion:nil];
}

#pragma mark - Authentication

- (void)authenticateWithAuthCode:(NSString *)authCode {
    [self.authViewController showNetworkActivityIndicator];
    
    [self.authManager authenticateWithAuthRequest:[self.nestRequestBuilder authenticationRequestWithAuthCode:authCode] success:^(void) {
        [self.authViewController hideNetworkActivityIndicator];

        [self.presentingController dismissViewControllerAnimated:YES completion:^{
            self.structurePresenter = [[NestStructurePresenter alloc] initWithPresentingViewController:_presentingController];
            [self.structurePresenter showView];
        }];
    } failure:^(NSError *error) {
        [self.authViewController hideNetworkActivityIndicator];
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
