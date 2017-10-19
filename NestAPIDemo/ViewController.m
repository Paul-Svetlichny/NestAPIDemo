//
//  ViewController.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/18/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "ViewController.h"
#import "NestAuthPresenter.h"

@interface ViewController ()

@property (strong, nonatomic) NestAuthPresenter *authPresenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _authPresenter = [[NestAuthPresenter alloc] initWithPresentingViewController:self];
}

- (IBAction)authenticateButtonPressed:(id)sender {
    [_authPresenter showView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
