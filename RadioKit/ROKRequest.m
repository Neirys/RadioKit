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

//#define NO_INTERNET

NSString * const kROKRequestTitleKey     =   @"title";
NSString * const kROKRequestArtistKey    =   @"artist";

@implementation ROKRequest

#pragma mark - Life cycle methods

- (instancetype)initWithURL:(NSString *)URL responseFormat:(ROKRequestResponseFormat)responseFormat titleKeyPath:(NSString *)titleKeyPath artistKeyPath:(NSString *)artistKeyPath
{
    if (self = [super init])
    {
        _requestURL = URL;
        _responseFormat = responseFormat;
        _titleKeyPath = titleKeyPath;
        _artistKeyPath = artistKeyPath;
    }
    return self;
}

+ (instancetype)requestWithURL:(NSString *)URL responseFormat:(ROKRequestResponseFormat)responseFormat titleKeyPath:(NSString *)titleKeyPath artistKeyPath:(NSString *)artistKeyPath
{
    return [[self alloc] initWithURL:URL responseFormat:responseFormat titleKeyPath:titleKeyPath artistKeyPath:artistKeyPath];
}

+ (instancetype)requestWithParameter:(id<ROKRequestParameter>)parameter
{
    return [[self alloc] initWithURL:parameter.requestURL responseFormat:parameter.responseFormat titleKeyPath:parameter.titleKeyPath artistKeyPath:parameter.artistKeyPath];
}

#pragma mark - Public methods

- (void)perform:(ROKRequestCompletionBlock)completion
{
    NSParameterAssert(completion);
    
    [self performRequestWithResponseFormat:self.responseFormat completion:^(NSArray *results, NSError *error) {
#ifndef NO_INTERNET
        completion(results, error);
#else
        NSArray *fixtures = @[
                              @{kROKRequestArtistKey : @"Eminem", kROKRequestTitleKey : @"Rythm or Reason"},
                              @{kROKRequestArtistKey : @"David Dallas", kROKRequestTitleKey : @"Runnin"},
                              ];
        completion(fixtures, nil);
#endif
    }];
}

#pragma mark - Private methods

- (void)performRequestWithResponseFormat:(ROKRequestResponseFormat)responseFormat completion:(ROKRequestCompletionBlock)completion
{
    NSParameterAssert(completion);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [self responseSerializerForResponseFormat:responseFormat];
    [manager GET:self.requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = (responseFormat == ROKRequestResponseFormatXML
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
    NSArray *titles = [response arrayValueForKeyPath:self.titleKeyPath];
    NSArray *artists = [response arrayValueForKeyPath:self.artistKeyPath];
    
    NSAssert(titles.count == artists.count, @"RadioKit error : titles array count differs from artists array count");
    
    NSUInteger count = titles.count;
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++)
    {
        NSString *title = ([titles[i] isKindOfClass:[NSArray class]]
                           ? [titles[i] componentsJoinedByString:@" / "]
                           : titles[i]);
        
        NSString *artist = ([artists[i] isKindOfClass:[NSArray class]]
                            ? [artists[i] componentsJoinedByString:@" / "]
                            : artists[i]);
        
        [results addObject:@{kROKRequestTitleKey : title, kROKRequestArtistKey : artist}];
    }
    
    return results.copy;
}

#pragma mark - Helper methods

- (AFHTTPResponseSerializer<AFURLResponseSerialization>*)responseSerializerForResponseFormat:(ROKRequestResponseFormat)responseFormat
{
    static NSDictionary *mapping;
    if (!mapping)
    {
        mapping = @{
                    @(ROKRequestResponseFormatJSON) : [AFJSONResponseSerializer new],
                    @(ROKRequestResponseFormatXML) : [AFXMLParserResponseSerializer new]
                    };
    }
    return mapping[@(responseFormat)] ?: [AFJSONResponseSerializer new];
}

@end
