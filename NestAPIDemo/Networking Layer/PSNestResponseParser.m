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
    
    if (jsonParsingError.code == 3840) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (!string || [string length] == 0)
            return @{@"error":jsonParsingError};;
        
        NSMutableDictionary *mutableFields = [NSMutableDictionary dictionary];
        
        for (NSString *line in [string componentsSeparatedByCharactersInSet:
                                [NSCharacterSet newlineCharacterSet]]) {
            if (!line || [line length] == 0 || [line hasPrefix:@":"])
                continue;
            
            @autoreleasepool {
                NSScanner *scanner = [[NSScanner alloc] initWithString:line];
                scanner.charactersToBeSkipped = [NSCharacterSet whitespaceCharacterSet];
                NSString *key, *value;
                [scanner scanUpToString:@":" intoString:&key];
                [scanner scanString:@":" intoString:nil];
                [scanner scanUpToString:@"\n" intoString:&value];
                
                if (key && value) {
                    if (mutableFields[key]) {
                        mutableFields[key] =
                        [mutableFields[key] stringByAppendingFormat:@"\n%@", value];
                    } else {
                        mutableFields[key] = value;
                    }
                }
            }
        }
        
        return [mutableFields copy];
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
