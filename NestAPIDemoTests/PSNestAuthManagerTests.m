//
//  PSNestAuthManagerTests.m
//  NestAPIDemoTests
//
//  Created by Paul Svetlichny on 10/19/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCMockitoIOS/OCMockitoIOS.h>

#import "PSNestAuthManager.h"

@interface PSNestAuthManagerTests : XCTestCase

@property (strong, nonatomic) PSNestAuthManager *sut;

@end

@implementation PSNestAuthManagerTests

- (void)setUp {
    [super setUp];
    _sut = [[PSNestAuthManager alloc] init];
}

- (void)tearDown {
    _sut = nil;
    [super tearDown];
}

- (void)testNestAPIManagerDidInvokePerformRequestWithProperRequest {
    
}

- (void)testAuthenticateWithAuthCodeShouldReturnFailureCallbackIfAuthCodeIsNil {
    __block BOOL failureBlockInvoked = NO;

    [_sut authenticateWithAuthCode:nil success:^(NSString *accessToken) {
    } failure:^(NSError *error) {
        failureBlockInvoked = YES;
    }];
    
    assertThatBool(failureBlockInvoked, isTrue());
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
