//
//  NPRadioRequest.m
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import "ROKRequest.h"

#import "ROKRadioProtocol.h"

#import "AFNetworking.h"
#import "XMLDictionary.h"

@interface ROKRequest ()
@end

@implementation ROKRequest

#pragma mark - Life cycle methods

- (instancetype)initWithRadio:(id<ROKRadio>)radio
{
    self = [super init];
    if (self)
    {
        _radio = radio;
    }
    return self;
}

+ (instancetype)requestWithRadio:(id<ROKRadio>)radio
{
    return [[self alloc] initWithRadio:radio];
}

#pragma mark - Public methods

- (void)perform:(ROKRequestCompletionBlock)completion
{
    NSParameterAssert(completion);
    
    [self performRequestWithResponseFormat:self.radio.responseFormat completion:^(NSArray *results, NSError *error) {
        completion(results, error);
    }];
}

#pragma mark - Private methods

- (void)performRequestWithResponseFormat:(ROKRadioResponseFormat)responseFormat completion:(ROKRequestCompletionBlock)completion
{
    NSParameterAssert(completion);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [self responseSerializerForResponseFormat:responseFormat];
    [manager GET:self.radio.requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = (responseFormat == ROKRadioResponseFormatXML
                                  ? [NSDictionary dictionaryWithXMLParser:responseObject]
                                  : (NSDictionary *)responseObject);
        NSArray *results = [self processResponse:response];
        completion(results, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (NSArray *)processResponse:(NSDictionary *)response
{
    NSArray *titles = [response arrayValueForKeyPath:self.radio.titleKeyPath];
    NSArray *artists = [response arrayValueForKeyPath:self.radio.artistKeyPath];
    
    NSAssert(titles.count == artists.count, @"RadioKit error : titles array count differs from artists array count");
    
    NSUInteger count = titles.count;
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        id title = titles[i];
        if ([title isKindOfClass:[NSArray class]])
            title = [title componentsJoinedByString:@" / "];
        
        id artist = artists[i];
        if ([artist isKindOfClass:[NSArray class]])
            artist = [artist componentsJoinedByString:@" / "];
        
        [results addObject:@{@"title" : title, @"artist" : artist}];
    }
    
    return results.copy;
}

#pragma mark - Helper methods

- (AFHTTPResponseSerializer<AFURLResponseSerialization>*)responseSerializerForResponseFormat:(ROKRadioResponseFormat)responseFormat
{
    static NSDictionary *mapping;
    if (!mapping)
    {
        mapping = @{
                    @(ROKRadioResponseFormatJSON) : [AFJSONResponseSerializer new],
                    @(ROKRadioResponseFormatXML) : [AFXMLParserResponseSerializer new]
                    };
    }
    return mapping[@(responseFormat)] ?: [AFJSONResponseSerializer new];
}

@end
