//
//  NestAuthPresenterTests.m
//  NestAPIDemoTests
//
//  Created by Paul Svetlichny on 10/21/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCMockitoIOS/OCMockitoIOS.h>

#import "NestAuthPresenter.h"

@interface NestAuthPresenterTests : XCTestCase

@property (strong, nonatomic) NestAuthPresenter *sut;

@end

@implementation NestAuthPresenterTests

- (void)setUp {
    [super setUp];
    self.sut = [[NestAuthPresenter alloc] initWithPresentingViewController:[[UIViewController alloc] init]];
}

- (void)tearDown {
    self.sut = nil;
    [super tearDown];
}

- (void)testIfPresentingControllerIsNotNilAfterInitialization {
    
    NestAuthPresenter *presenter = [[NestAuthPresenter alloc] initWithPresentingViewController:nil];

    assertThat(presenter.presentingController, is(notNilValue()));
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
