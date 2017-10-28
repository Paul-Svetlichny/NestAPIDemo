//
//  PSNestThermostatManager.m
//  NestAPIDemo
//
//  Created by Paul Svetlichny on 10/21/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSNestThermostatManager.h"
#import "PSNestAPIManager.h"
#import "PSNestRequestBuilder.h"
#import "PSNestSessionManager.h"
#import "PSNestResponseParser.h"
#import "NestThermostat.h"

typedef void(^PSNestThermostatCallback)(NestThermostat *thermostat, NSError *error);

@interface PSNestThermostatManager () <PSNestAPIManagerDelegate>

@property (strong, nonatomic) PSNestSessionManager *sessionManager;
@property (strong, nonatomic) PSNestAPIManager *apiManager;
@property (strong, nonatomic) PSNestRequestBuilder *nestRequestBuilder;

@property (strong, nonatomic) PSNestThermostatCallback callback;

@end

@implementation PSNestThermostatManager

- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [[PSNestSessionManager alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
        self.apiManager = [[PSNestAPIManager alloc] init];
        self.apiManager.delegate = self;
        self.nestRequestBuilder = [[PSNestRequestBuilder alloc] init];
    }
    
    return self;
}

- (void)nestThermostatWithThermostatId:(NSString *)thermostatId andCallback:(void (^)(NestThermostat *thermostat, NSError *error))callback {
    
    self.callback = callback;

    NSMutableURLRequest *request = [self.nestRequestBuilder requestForBaseURLString:@"https://developer-api.nest.com" andPath:[NSString stringWithFormat:@"devices/thermostats/%@", thermostatId] andRequestMethod:@"GET" withData:nil andAccessToken:self.sessionManager.accessToken];

    [self.apiManager performRequest:request];
}

- (void)setTargetTemperature:(NSNumber *)targetTemperature forTemperatureScale:(NSString *)scale forThermostsatWithId:(NSString *)thermostatId withCallback:(void (^)(NSNumber *targetTemperature))callback {
    
    __block NSString *parameterKey;
    if ([scale isEqualToString:@"C"]) {
        parameterKey = @"target_temperature_c";
    } else {
        parameterKey = @"target_temperature_f";
    }

    NSDictionary *dictionary = @{parameterKey : targetTemperature};
    __block NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:nil];

    NSMutableURLRequest *request = [self.nestRequestBuilder requestForBaseURLString:@"https://developer-api.nest.com" andPath:[NSString stringWithFormat:@"devices/thermostats/%@/", thermostatId] andRequestMethod:@"PUT" withData:data andAccessToken:self.sessionManager.accessToken];
    
    __block PSNestResponseParser *parser = [[PSNestResponseParser alloc] init];
    
    [self.apiManager performRequest:request success:^(NSData *data) {
        NSDictionary *thermostatDictionary = [parser responseDictionaryFromResponseData:data];
        if (!thermostatDictionary[@"error"]) {
            callback(thermostatDictionary[parameterKey]);
        } else {
            callback(nil);
        }
    } redirect:^(NSHTTPURLResponse *responseURL) {
        NSMutableURLRequest *redirectRequest = [self.nestRequestBuilder requestForBaseURLString:[[responseURL URL] absoluteString] andPath:nil andRequestMethod:@"PUT" withData:data andAccessToken:self.sessionManager.accessToken];
        [self.apiManager performRequest:redirectRequest success:^(NSData *data) {
            NSDictionary *thermostatDictionary = [parser responseDictionaryFromResponseData:data];
            if (!thermostatDictionary[@"error"]) {
                callback(thermostatDictionary[parameterKey]);
            } else {
                callback(nil);
            }
        } redirect:^(NSHTTPURLResponse *responseURL) {
        } failure:^(NSError *error) {
            NSLog(@"error: %@", error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)setTemperatureScale:(NSString *)scale forThermostsatWithId:(NSString *)thermostatId withCallback:(void (^)(NSString *))callback {

    NSDictionary *dictionary = @{@"temperature_scale" : scale};
    __block NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:nil];;

    NSMutableURLRequest *request = [self.nestRequestBuilder requestForBaseURLString:@"https://developer-api.nest.com" andPath:[NSString stringWithFormat:@"devices/thermostats/%@/", thermostatId] andRequestMethod:@"PUT" withData:data andAccessToken:self.sessionManager.accessToken];
    
    __block PSNestResponseParser *parser = [[PSNestResponseParser alloc] init];
    
    [self.apiManager performRequest:request success:^(NSData *data) {
        NSDictionary *thermostatDictionary = [parser responseDictionaryFromResponseData:data];
        if (!thermostatDictionary[@"error"]) {
            callback(thermostatDictionary[@"temperature_scale"]);
        } else {
            callback(nil);
        }
    } redirect:^(NSHTTPURLResponse *responseURL) {
        NSMutableURLRequest *redirectRequest = [self.nestRequestBuilder requestForBaseURLString:[[responseURL URL] absoluteString] andPath:nil andRequestMethod:@"PUT" withData:data andAccessToken:self.sessionManager.accessToken];
        [self.apiManager performRequest:redirectRequest success:^(NSData *data) {
            NSDictionary *thermostatDictionary = [parser responseDictionaryFromResponseData:data];
            if (!thermostatDictionary[@"error"]) {
                callback(thermostatDictionary[@"temperature_scale"]);
            } else {
                callback(nil);
            }
        } redirect:^(NSHTTPURLResponse *responseURL) {
        } failure:^(NSError *error) {
            NSLog(@"error: %@", error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark - PSNestAPIManager Delegate

- (void)nestAPIManager:(id)manager didRecieveData:(NSData *)data {
    PSNestResponseParser *parser = [[PSNestResponseParser alloc] init];
    
    NSDictionary *dictionary = [parser responseDictionaryFromResponseData:data];
    
    if (dictionary[@"data"] && ![dictionary[@"data"] isEqualToString:@"null"]) {
        NSData *jsonData = [dictionary[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NestThermostat *thermostat = [[NestThermostat alloc] initWithDictionary:json[@"data"]];
        
        self.callback(thermostat, nil);
    }
}

- (void)nestAPIManager:(id)manager didRecieveRedirectURLWithResponse:(NSURLResponse *)response {
    NSMutableURLRequest *redirectRequest = [self.nestRequestBuilder requestForBaseURLString:[[response URL] absoluteString] andPath:nil andRequestMethod:@"GET" withData:nil andAccessToken:self.sessionManager.accessToken];

    [self.apiManager performRequest:redirectRequest];
}

- (void)nestAPIManager:(id)manager didFinishRequestWithError:(NSError *)error {
}

@end
