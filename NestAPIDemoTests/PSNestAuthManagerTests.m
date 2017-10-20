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
#import "NestAccessToken.h"

@interface PSNestAuthManager (DependencyInjection)

- (void)setUserDefaults:(NSUserDefaults *)userDefaults;
- (NSURL *)authURLForAuthCode:(NSString *)authCode;

@end

@interface PSNestAuthManagerTests : XCTestCase

@property (strong, nonatomic) PSNestAuthManager *sut;

@end

@implementation PSNestAuthManagerTests

- (void)setUp {
    [super setUp];
    _sut = [PSNestAuthManager sharedInstance];
}

- (void)tearDown {
    _sut = nil;
    [super tearDown];
}

- (void)testAccessTokenGetterShouldReturnNilIfAccessTokenIsNotStoredProperly {
    NSUserDefaults *mockUserDefaults = mock([NSUserDefaults class]);
    _sut.userDefaults = mockUserDefaults;
    [given([mockUserDefaults objectForKey:@"nestAccessToken"]) willReturn:nil];

    assertThat(_sut.accessToken, is(nilValue()));
}

- (void)testAccessTokenGetterShouldReturnValidTokenIfStoredProperly {
    NSUserDefaults *mockUserDefaults = mock([NSUserDefaults class]);
    NestAccessToken *accessToken = [NestAccessToken tokenWithTokenString:@"Some string" expiresIn:10];
    NSData *encodedToken = [NSKeyedArchiver archivedDataWithRootObject:accessToken];

    _sut.userDefaults = mockUserDefaults;
    [given([mockUserDefaults objectForKey:@"nestAccessToken"]) willReturn:encodedToken];
    
    assertThat(_sut.accessToken, isNot(nilValue()));
}

- (void)testAuthCodeURLShouldReturnNilIfAuthCodeIsNil {
    assertThat([_sut authURLForAuthCode:nil], is(nilValue()));
}

- (void)testAuthenticateWithAuthCodeShouldReturnFailureCallbackIfAuthCodeIsNil {
    [given([_sut authURLForAuthCode:nil]) willReturn:nil];
    
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
