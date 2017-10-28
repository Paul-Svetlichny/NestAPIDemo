//
//  PSNestStructureManager.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestStructureManager.h"
#import "PSNestAPIManager.h"
#import "PSNestRequestBuilder.h"
#import "PSNestSessionManager.h"
#import "PSNestResponseParser.h"
#import "NestStructure.h"

typedef void(^PSNestStructureCallback)(NestStructure *structure, NSError *error);

@interface PSNestStructureManager () <PSNestAPIManagerDelegate>

@property (strong, nonatomic) PSNestSessionManager *sessionManager;
@property (strong, nonatomic) PSNestAPIManager *apiManager;
@property (strong, nonatomic) PSNestRequestBuilder *nestRequestBuilder;

@property (strong, nonatomic) PSNestStructureCallback callback;

@end

@implementation PSNestStructureManager

- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [[PSNestSessionManager alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
        self.apiManager = [[PSNestAPIManager alloc] init];
        self.apiManager.delegate = self;
        self.nestRequestBuilder = [[PSNestRequestBuilder alloc] init];
    }
    
    return self;
}

- (void)nestStructureWithCallback:(void (^)(NestStructure *structure, NSError *error))callback {
    
    self.callback = callback;
    
    NSMutableURLRequest *request = [self.nestRequestBuilder requestForBaseURLString:@"https://developer-api.nest.com" andPath:@"structures" andRequestMethod:@"GET" withData:nil andAccessToken:self.sessionManager.accessToken];
    
    [self.apiManager performRequest:request];
}

#pragma mark - PSNestAPIManager Delegate

- (void)nestAPIManager:(id)manager didRecieveData:(NSData *)data {
    PSNestResponseParser *parser = [[PSNestResponseParser alloc] init];
    
    NSDictionary *dictionary = [parser responseDictionaryFromResponseData:data];
    
    if (dictionary[@"data"] && ![dictionary[@"data"] isEqualToString:@"null"]) {
        NSData *jsonData = [dictionary[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSArray *structures = [json[@"data"] allKeys];
        
        if (structures.count > 0) {
            NSString *structureId = structures[0];
            
            NestStructure *structure = [[NestStructure alloc] initWithDictionary:json[@"data"][structureId]];
            self.callback(structure, nil);
        }
    }
}

- (void)nestAPIManager:(id)manager didRecieveRedirectURLWithResponse:(NSURLResponse *)response {
    NSMutableURLRequest *redirectRequest = [self.nestRequestBuilder requestForBaseURLString:[[response URL] absoluteString] andPath:nil andRequestMethod:@"GET" withData:nil andAccessToken:self.sessionManager.accessToken];
    
    [self.apiManager performRequest:redirectRequest];
}

- (void)nestAPIManager:(id)manager didFinishRequestWithError:(NSError *)error {
}

@end
