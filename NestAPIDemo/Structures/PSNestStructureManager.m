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

@implementation PSNestStructureManager

- (void)nestStructureWithCallback:(void (^)(NestStructure *, NSError *))callback {
    PSNestSessionManager *sessionManager = [[PSNestSessionManager alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    PSNestAPIManager *apiManager = [[PSNestAPIManager alloc] initWithURLSession:sessionManager.urlSession];
    PSNestRequestBuilder *nestRequestBuilder = [[PSNestRequestBuilder alloc] init];
    NSMutableURLRequest *request = [nestRequestBuilder requestForBaseURLString:@"https://developer-api.nest.com" andPath:@"structures" andRequestMethod:@"GET" withData:nil andAccessToken:sessionManager.accessToken];
    
    __block PSNestResponseParser *parser = [[PSNestResponseParser alloc] init];
    
    [apiManager performRequest:request success:^(NSData *data) {
        NSDictionary *structureDictionary = [parser responseDictionaryFromResponseData:data];
        if (!structureDictionary[@"error"]) {
            NSArray *structures = [structureDictionary allKeys];
            
            if (structures.count > 0) {
                NSString *structureId = structures[0];
                
                NestStructure *structure = [[NestStructure alloc] initWithDictionary:structureDictionary[structureId]];
                callback(structure, nil);
            } else {
            callback(nil, structureDictionary[@"error"]);
            }
        }
    } redirect:^(NSHTTPURLResponse *responseURL) {
        NSMutableURLRequest *redirectRequest = [nestRequestBuilder requestForBaseURLString:[[responseURL URL] absoluteString] andPath:nil andRequestMethod:@"GET" withData:nil andAccessToken:sessionManager.accessToken];
        [apiManager performRequest:redirectRequest success:^(NSData *data) {
            NSDictionary *structureDictionary = [parser responseDictionaryFromResponseData:data];
            if (!structureDictionary[@"error"]) {
                NSArray *structures = [structureDictionary allKeys];
                
                if (structures.count > 0) {
                    NSString *structureId = structures[0];

                    NestStructure *structure = [[NestStructure alloc] initWithDictionary:structureDictionary[structureId]];
                    callback(structure, nil);
                } else {
                    callback(nil, [NSError errorWithDomain:@"com.fireflydevelop.nestApiDemo" code:0 userInfo:@{ NSLocalizedDescriptionKey : @"Something went wrong"}]);
                }
            } else {
                callback(nil, structureDictionary[@"error"]);
            }
        } redirect:^(NSHTTPURLResponse *responseURL) {
        } failure:^(NSError *error) {
            NSLog(@"error: %@", error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
