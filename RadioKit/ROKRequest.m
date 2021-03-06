//
//  ROKRequest.m
//
//  Version 1.0
//
//  https://github.com/Neirys/RadioKit
//
//  Created by Yaman JAIOUCH on 23/05/2014.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "ROKRequest.h"

#import "ROKTrack.h"

#import "AFNetworking.h"
#import "XMLDictionary.h"

//#define NO_INTERNET

NSString * const kROKRequestTitleKey     =   @"title";
NSString * const kROKRequestArtistKey    =   @"artist";

@interface ROKRequest ()
{
    __unsafe_unretained Class _mappingClass;
}

@end

@interface ROKRequest (_ROKMapping)

- (NSArray *)mapRawTracksToObjects:(NSArray *)rawTracks;

@end

@implementation ROKRequest

- (id)init
{
    if (self = [super init])
    {
        _mappingClass = [ROKTrack class];
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)URL responseFormat:(ROKRequestResponseFormat)responseFormat titleKeyPath:(NSString *)titleKeyPath artistKeyPath:(NSString *)artistKeyPath
{
    if (self = [self init])
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

- (void)perform:(ROKRequestCompletionBlock)completion
{
    NSParameterAssert(completion);
    
    [self performRequestWithResponseFormat:self.responseFormat completion:^(NSArray *results, NSError *error) {
#ifdef NO_INTERNET
        results = @[
                    @{kROKRequestArtistKey : @"Eminem", kROKRequestTitleKey : @"Rythm or Reason"},
                    @{kROKRequestArtistKey : @"David Dallas", kROKRequestTitleKey : @"Runnin"},
                    ];
#endif
        results = _mappingClass ? [self mapRawTracksToObjects:results] : results;
        completion(results, error);
    }];
}

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

@implementation ROKRequest (ROKMapping)

@dynamic mappingClass;

- (Class<ROKTrack>)mappingClass
{
    return _mappingClass;
}

- (void)setMappingClass:(Class<ROKTrack>)mappingClass
{
    _mappingClass = mappingClass;
}

@end

@implementation ROKRequest (_ROKMapping)

- (NSArray *)mapRawTracksToObjects:(NSArray *)rawTracks
{
    if (!_mappingClass || ![_mappingClass conformsToProtocol:@protocol(ROKTrack)])
        return rawTracks;
    
    NSMutableArray *mappedTracks = [NSMutableArray arrayWithCapacity:rawTracks.count];
    for (NSDictionary *track in rawTracks)
    {
        id<ROKTrack> mappedTrack = [[_mappingClass alloc] init];
        mappedTrack.title = track[kROKRequestTitleKey];
        mappedTrack.artist = track[kROKRequestArtistKey];
        [mappedTracks addObject:mappedTrack];
    }
    
    return mappedTracks;
}

@end
