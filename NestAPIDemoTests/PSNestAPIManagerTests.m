//
//  PSNestAPIManagerTests.m
//  NestAPIDemoTests
//
//  Created by Paul Svetlichny on 10/29/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PSNestAPIManager.h"
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCMockitoIOS/OCMockitoIOS.h>

@interface PSNestAPIManagerTests : XCTestCase

@property (strong, nonatomic) PSNestAPIManager *apiManager;

@end

@implementation PSNestAPIManagerTests

- (void)setUp {
    [super setUp];
    self.apiManager = [[PSNestAPIManager alloc] init];
}

- (void)tearDown {
    self.apiManager = nil;
    [super tearDown];
}

- (void)testPerformRequestWithCompletionBlockShouldInvokeFailuerHanlderIfRequestIsNil {
    __block BOOL isFailureHandlerInvoked = NO;
    [self.apiManager performRequest:nil success:nil redirect:nil failure:^(NSError *error) {
        isFailureHandlerInvoked = YES;
    }];
    
    assertThatBool(isFailureHandlerInvoked, isTrue());
}

- (void)testPerformRequestWithCompletionBlockShouldInvokeRedirectHandlerIfResponseStatusIs401 {
    NSURLSession *mockSession = mock([NSURLSession class]);
    
    self.apiManager.urlSession = mockSession;
    
    [given([mockSession dataTaskWithRequest:anything() completionHandler:anything()]) willDo:^id (NSInvocation * invocation) {
        NSArray *args = [invocation mkt_arguments];
        void (^successHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) = args[1];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:401 HTTPVersion:@"" headerFields:nil];
        successHandler([NSData data], response, nil);
        return nil;
    }];
    
    __block BOOL isRedirectHandlerInvoked = NO;
    [self.apiManager performRequest:[NSURLRequest new] success:nil redirect:^(NSHTTPURLResponse *responseURL) {
        isRedirectHandlerInvoked = YES;
    } failure:nil];
    
    assertThatBool(isRedirectHandlerInvoked, isTrue());
}

- (void)testPerformRequestWithCompletionBlockShouldInvokeRedirectHandlerIfResponseStatusIs307 {
    NSURLSession *mockSession = mock([NSURLSession class]);
    
    self.apiManager.urlSession = mockSession;
    
    [given([mockSession dataTaskWithRequest:anything() completionHandler:anything()]) willDo:^id (NSInvocation * invocation) {
        NSArray *args = [invocation mkt_arguments];
        void (^successHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) = args[1];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:307 HTTPVersion:@"" headerFields:nil];
        successHandler([NSData data], response, nil);
        return nil;
    }];
    
    __block BOOL isRedirectHandlerInvoked = NO;
    [self.apiManager performRequest:[NSURLRequest new] success:nil redirect:^(NSHTTPURLResponse *responseURL) {
        isRedirectHandlerInvoked = YES;
    } failure:nil];
    
    assertThatBool(isRedirectHandlerInvoked, isTrue());
}

- (void)testPerformRequestWithCompletionBlockShouldInvokeFailureHandlerIfUnauthorized {
    NSURLSession *mockSession = mock([NSURLSession class]);
    
    self.apiManager.urlSession = mockSession;
    
    [given([mockSession dataTaskWithRequest:anything() completionHandler:anything()]) willDo:^id (NSInvocation * invocation) {
        NSArray *args = [invocation mkt_arguments];
        void (^successHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) = args[1];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:401 HTTPVersion:@"" headerFields:@{@"Content-Length":@"0"}];
        successHandler([NSData data], response, nil);
        return nil;
    }];
    
    __block BOOL isFailureHandlerInvoked = NO;
    [self.apiManager performRequest:[NSURLRequest new] success:nil redirect:nil failure:^(NSError *error) {
        isFailureHandlerInvoked = YES;
    }];
    
    assertThatBool(isFailureHandlerInvoked, isTrue());
}

- (void)testPerformRequestWithCompletionBlockShouldInvokeFailuerHandlerIfErrorOccured {
    NSURLSession *mockSession = mock([NSURLSession class]);
    
    self.apiManager.urlSession = mockSession;
    
    [given([mockSession dataTaskWithRequest:anything() completionHandler:anything()]) willDo:^id (NSInvocation * invocation) {
        NSArray *args = [invocation mkt_arguments];
        void (^successHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) = args[1];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:404 HTTPVersion:@"" headerFields:nil];
        successHandler(nil, response, [NSError errorWithDomain:@"com.fireflydevelop.NestAPIDemo" code:404 userInfo:nil]);
        return nil;
    }];
    
    __block BOOL isFailureHandlerInvoked = NO;
    [self.apiManager performRequest:[NSURLRequest new] success:nil redirect:nil failure:^(NSError *error) {
        isFailureHandlerInvoked = YES;
    }];
    
    assertThatBool(isFailureHandlerInvoked, isTrue());
}

- (void)testPerformRequestWithCompletionBlockShouldInvokeSuccessHandlerIfNoErrorOccured {
    NSURLSession *mockSession = mock([NSURLSession class]);
    
    self.apiManager.urlSession = mockSession;
    
    [given([mockSession dataTaskWithRequest:anything() completionHandler:anything()]) willDo:^id (NSInvocation * invocation) {
        NSArray *args = [invocation mkt_arguments];
        void (^successHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) = args[1];
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:@"" headerFields:nil];
        successHandler([NSData data], response, nil);
        return nil;
    }];
    
    __block BOOL isSuccessHandlerInvoked = NO;
    [self.apiManager performRequest:[NSURLRequest new] success:^(NSData *data) {
        isSuccessHandlerInvoked = YES;
    } redirect:nil failure:nil];
    
    assertThatBool(isSuccessHandlerInvoked, isTrue());
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
