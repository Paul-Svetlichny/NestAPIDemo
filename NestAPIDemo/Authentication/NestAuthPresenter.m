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

@property (strong, nonatomic) NestAuthViewController *authController;
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

- (NestAuthViewController *)authController {
    if (!_authController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
        _authController = (NestAuthViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NestAuthViewController"];
        
        _authController.request = [self.nestRequestBuilder loginRequest];
        _authController.delegate = self;
    }
    
    return _authController;
}

- (void)showView {
    [self.presentingController presentViewController:self.authController animated:YES completion:nil];
}

#pragma mark - Authentication

- (void)authenticateWithAuthCode:(NSString *)authCode {
    
    [self.authManager authenticateWithAuthRequest:[self.nestRequestBuilder authenticationRequestWithAuthCode:authCode] success:^(void) {
        [self.presentingController dismissViewControllerAnimated:YES completion:^{
            self.structurePresenter = [[NestStructurePresenter alloc] initWithPresentingViewController:_presentingController];
            [self.structurePresenter showView];
        }];

//        NSLog(@"access token: %@", accessToken);
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
