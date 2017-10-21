//
//  SplashScreenViewController.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/21/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "PSNestSessionManager.h"
#import "NestStructurePresenter.h"
#import "NestAuthPresenter.h"

@interface SplashScreenViewController ()

@property (strong, nonatomic) NestStructurePresenter *structurePresenter;
@property (strong, nonatomic) NestAuthPresenter *authPresenter;
@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PSNestSessionManager *sessionManager = [[PSNestSessionManager alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    
    if ([sessionManager isValidSession]) {
        _structurePresenter = [[NestStructurePresenter alloc] initWithPresentingViewController:self];
        [_structurePresenter showView];
    } else {
        _authPresenter = [[NestAuthPresenter alloc] initWithPresentingViewController:self];
        [_authPresenter showView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
