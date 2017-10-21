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
#import "PSNestAPIManager.h"
#import "PSNestResponseParser.h"
#import "PSNestSessionManager.h"

@interface PSNestAuthManagerTests : XCTestCase

@property (strong, nonatomic) PSNestAuthManager *authManager;

@end

@implementation PSNestAuthManagerTests

- (void)setUp {
    [super setUp];
    self.authManager = [[PSNestAuthManager alloc] init];
}

- (void)tearDown {
    self.authManager = nil;
    [super tearDown];
}

- (void)testNestAPIManagerDidInvokePerformRequestWithProperRequest {
    PSNestAPIManager *mockAPIManager = mock([PSNestAPIManager class]);
    
    self.authManager.nestAPIManager = mockAPIManager;
    NSURLRequest *authRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

    [self.authManager authenticateWithAuthRequest:authRequest success:nil failure:nil];

    [verify(mockAPIManager) performRequest:authRequest success:anything() failure:anything()];
}

- (void)testDataPassedToResponseParserAfterSuccess {
    PSNestAPIManager *mockAPIManager = mock([PSNestAPIManager class]);
    PSNestResponseParser *mockParserManager = mock([PSNestResponseParser class]);

    self.authManager.nestAPIManager = mockAPIManager;
    self.authManager.responseParser = mockParserManager;

    NSData *dataToTest = [[NSData alloc] init];

    [given([mockParserManager responseDictionaryFromResponseData:anything()]) willReturn:@{}];
    
    [givenVoid([mockAPIManager performRequest:anything() success:anything() failure:anything()]) willDo:^id (NSInvocation *invocation) {
        NSArray *args = [invocation mkt_arguments];
        void (^successHandler)(NSData *data) = args[1];
        successHandler(dataToTest);
        return nil;
    }];
    
    [self.authManager authenticateWithAuthRequest:nil success:^(void) {
        
    } failure:nil];

    [verify(mockParserManager) responseDictionaryFromResponseData:dataToTest];
}

- (void)testDictionaryPassedToNestSessionManagerAfterSuccess {
    PSNestAPIManager *mockAPIManager = mock([PSNestAPIManager class]);
    PSNestResponseParser *mockParserManager = mock([PSNestResponseParser class]);
    PSNestSessionManager *mockSessionManager = mock([PSNestSessionManager class]);

    self.authManager.nestAPIManager = mockAPIManager;
    self.authManager.responseParser = mockParserManager;
    self.authManager.nestSessionManager = mockSessionManager;

    NSDictionary *dictionary = @{@"something":@"something good"};
    
    [given([mockParserManager responseDictionaryFromResponseData:anything()]) willReturn:dictionary];
    
    [givenVoid([mockAPIManager performRequest:anything() success:anything() failure:anything()]) willDo:^id (NSInvocation *invocation) {
        NSArray *args = [invocation mkt_arguments];
        void (^successHandler)(NSData *data) = args[1];
        successHandler(nil);
        return nil;
    }];
    
    [self.authManager authenticateWithAuthRequest:nil success:^(void) {
        
    } failure:nil];
    
    [verify(mockSessionManager) setAccessTokenWithDictionary:dictionary];
}

- (void)testSuccessHandlerInvokedAfterSuccess {
    PSNestAPIManager *mockAPIManager = mock([PSNestAPIManager class]);
    PSNestResponseParser *mockParserManager = mock([PSNestResponseParser class]);
    
    self.authManager.nestAPIManager = mockAPIManager;
    self.authManager.responseParser = mockParserManager;
    
    [given([mockParserManager responseDictionaryFromResponseData:anything()]) willReturn:@{}];
    
    [givenVoid([mockAPIManager performRequest:anything() success:anything() failure:anything()]) willDo:^id (NSInvocation *invocation) {
        NSArray *args = [invocation mkt_arguments];
        void (^successHandler)(NSData *data) = args[1];
        successHandler(nil);
        return nil;
    }];
    
    __block BOOL successHandlerCalled = NO;
    
    [self.authManager authenticateWithAuthRequest:nil success:^(void) {
        successHandlerCalled = YES;
    } failure:nil];
    
    assertThatBool(successHandlerCalled, isTrue());
}

- (void)testFailureHandlerInvokedAfterSuccessWithWrongResponseData {
    PSNestAPIManager *mockAPIManager = mock([PSNestAPIManager class]);
    PSNestResponseParser *mockParserManager = mock([PSNestResponseParser class]);
    
    self.authManager.nestAPIManager = mockAPIManager;
    self.authManager.responseParser = mockParserManager;
    
    NSError *returnError = [NSError errorWithDomain:@"someDomain" code:0 userInfo:nil];
    
    [given([mockParserManager responseDictionaryFromResponseData:anything()]) willReturn:@{@"error":returnError}];
    
    [givenVoid([mockAPIManager performRequest:anything() success:anything() failure:anything()]) willDo:^id (NSInvocation *invocation) {
        NSArray *args = [invocation mkt_arguments];
        void (^successHandler)(NSData *data) = args[1];
        successHandler(nil);
        return nil;
    }];
    
    [self.authManager authenticateWithAuthRequest:nil success:nil failure:^(NSError *error) {
        assertThat(error, is(returnError));
    }];
}

- (void)testFailureHandlerInvokedAfterFailure {
    PSNestAPIManager *mockAPIManager = mock([PSNestAPIManager class]);
    
    self.authManager.nestAPIManager = mockAPIManager;
    
    NSError *returnError = [NSError errorWithDomain:@"someDomain" code:0 userInfo:nil];

    [givenVoid([mockAPIManager performRequest:anything() success:anything() failure:anything()]) willDo:^id (NSInvocation *invocation) {
        NSArray *args = [invocation mkt_arguments];
        void (^failureHandler)(NSError *error) = args[2];
        failureHandler(returnError);
        return nil;
    }];
    
    [self.authManager authenticateWithAuthRequest:nil success:nil failure:^(NSError *error) {
        assertThat(error, is(returnError));
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
