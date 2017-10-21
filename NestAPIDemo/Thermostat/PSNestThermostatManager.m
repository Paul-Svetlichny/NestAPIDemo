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

@interface PSNestThermostatManager ()

@property (strong, nonatomic) PSNestSessionManager *sessionManager;
@property (strong, nonatomic) PSNestAPIManager *apiManager;
@property (strong, nonatomic) PSNestRequestBuilder *nestRequestBuilder;
@end

@implementation PSNestThermostatManager

- (instancetype)init {
    if (self = [super init]) {
        _sessionManager = [[PSNestSessionManager alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
        _apiManager = [[PSNestAPIManager alloc] initWithURLSession:_sessionManager.urlSession];
        _nestRequestBuilder = [[PSNestRequestBuilder alloc] init];
    }
    
    return self;
}

- (void)nestThermostatWithThermostatId:(NSString *)thermostatId andCallback:(void (^)(NestThermostat *thermostat, NSError *error))callback {
    
    NSMutableURLRequest *request = [_nestRequestBuilder requestForBaseURLString:@"https://developer-api.nest.com" andPath:[NSString stringWithFormat:@"devices/thermostats/%@", thermostatId] andRequestMethod:@"GET" withData:nil andAccessToken:_sessionManager.accessToken];
    
    __block PSNestResponseParser *parser = [[PSNestResponseParser alloc] init];
    
    [_apiManager performRequest:request success:^(NSData *data) {
        NSDictionary *thermostatDictionary = [parser responseDictionaryFromResponseData:data];
        if (!thermostatDictionary[@"error"]) {
            NestThermostat *thermostat = [[NestThermostat alloc] initWithDictionary:thermostatDictionary];
            callback(thermostat, nil);
        } else {
            callback(nil, thermostatDictionary[@"error"]);
        }
    } redirect:^(NSHTTPURLResponse *responseURL) {
        NSMutableURLRequest *redirectRequest = [_nestRequestBuilder requestForBaseURLString:[[responseURL URL] absoluteString] andPath:nil andRequestMethod:@"GET" withData:nil andAccessToken:_sessionManager.accessToken];
        [_apiManager performRequest:redirectRequest success:^(NSData *data) {
            NSDictionary *thermostatDictionary = [parser responseDictionaryFromResponseData:data];
            if (!thermostatDictionary[@"error"]) {
                NestThermostat *thermostat = [[NestThermostat alloc] initWithDictionary:thermostatDictionary];
                callback(thermostat, nil);
            } else {
                callback(nil, thermostatDictionary[@"error"]);
            }
        } redirect:^(NSHTTPURLResponse *responseURL) {
        } failure:^(NSError *error) {
            NSLog(@"error: %@", error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)setTargetTemperature:(NSNumber *)targetTemperature forTemperatureScale:(NSString *)scale forThermostsatWithId:(NSString *)thermostatId withCallback:(void (^)(NSNumber *targetTemperature))callback {
    
    __block NSData *data;
    __block NSString *parameterKey;
    if ([scale isEqualToString:@"C"]) {
        parameterKey = @"target_temperature_c";
    } else {
        parameterKey = @"target_temperature_f";
    }

    NSDictionary *dictionary = @{parameterKey : targetTemperature};
    data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:nil];

    NSMutableURLRequest *request = [_nestRequestBuilder requestForBaseURLString:@"https://developer-api.nest.com" andPath:[NSString stringWithFormat:@"devices/thermostats/%@/", thermostatId] andRequestMethod:@"PUT" withData:data andAccessToken:_sessionManager.accessToken];
    
    __block PSNestResponseParser *parser = [[PSNestResponseParser alloc] init];
    
    [_apiManager performRequest:request success:^(NSData *data) {
        NSDictionary *thermostatDictionary = [parser responseDictionaryFromResponseData:data];
        if (!thermostatDictionary[@"error"]) {
            callback(thermostatDictionary[parameterKey]);
        } else {
            callback(nil);
        }
    } redirect:^(NSHTTPURLResponse *responseURL) {
        NSMutableURLRequest *redirectRequest = [_nestRequestBuilder requestForBaseURLString:[[responseURL URL] absoluteString] andPath:nil andRequestMethod:@"PUT" withData:data andAccessToken:_sessionManager.accessToken];
        [_apiManager performRequest:redirectRequest success:^(NSData *data) {
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

    NSMutableURLRequest *request = [_nestRequestBuilder requestForBaseURLString:@"https://developer-api.nest.com" andPath:[NSString stringWithFormat:@"devices/thermostats/%@/", thermostatId] andRequestMethod:@"PUT" withData:data andAccessToken:_sessionManager.accessToken];
    
    __block PSNestResponseParser *parser = [[PSNestResponseParser alloc] init];
    
    [_apiManager performRequest:request success:^(NSData *data) {
        NSDictionary *thermostatDictionary = [parser responseDictionaryFromResponseData:data];
        if (!thermostatDictionary[@"error"]) {
            callback(thermostatDictionary[@"temperature_scale"]);
        } else {
            callback(nil);
        }
    } redirect:^(NSHTTPURLResponse *responseURL) {
        NSMutableURLRequest *redirectRequest = [_nestRequestBuilder requestForBaseURLString:[[responseURL URL] absoluteString] andPath:nil andRequestMethod:@"PUT" withData:data andAccessToken:_sessionManager.accessToken];
        [_apiManager performRequest:redirectRequest success:^(NSData *data) {
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

@end
