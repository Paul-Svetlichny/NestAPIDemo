//
//  PSNestResponseParser.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/20/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestResponseParser.h"
#import "PSNestURLAggregator.h"

@implementation PSNestResponseParser

- (NSDictionary *)responseDictionaryFromResponseData:(NSData *)data {
    NSError *jsonParsingError;
    NSDictionary *requestJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions
                                                                  error:&jsonParsingError];
    
    if (!jsonParsingError) {
        return requestJSON;
    }
    
    return @{@"error":jsonParsingError};
}

- (NSString *)authCodeFromResponse:(NSURL *)responseURL {
    
    PSNestURLAggregator *urlAggregator = [[PSNestURLAggregator alloc] init];
    NSURL *redirectURL = urlAggregator.redirectURL;
    
    if ([[responseURL host] isEqualToString:[redirectURL host]]) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:responseURL
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSString *authCode = [self valueForKey:@"code" fromQueryItems:queryItems];
     
        return authCode;
    }
    
    return nil;
}

- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

@end
