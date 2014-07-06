//
//  NPRadio.m
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import "ROKRadio.h"

#import "ROKTrack.h"

@interface ROKRadio ()
{
    __unsafe_unretained Class _trackMappingClass;
}

@end

@implementation ROKRadio

#pragma mark - Life cycle

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (instancetype)initWithRequestURL:(NSString *)requestURL
                    responseFormat:(ROKRequestResponseFormat)responseFormat
                        trackOrder:(ROKRadioTrackOrder)trackOrder
                      titleKeyPath:(NSString *)titleKeyPath
                     artistKeyPath:(NSString *)artistKeyPath
{
    self = [self init];
    if (self)
    {
        _requestURL = requestURL;
        _responseFormat = responseFormat;
        _trackOrder = trackOrder;
        _titleKeyPath = titleKeyPath;
        _artistKeyPath = artistKeyPath;
    }
    return self;
}


+ (instancetype)radioWithRequestURL:(NSString *)requestURL
                     responseFormat:(ROKRequestResponseFormat)responseFormat
                         trackOrder:(ROKRadioTrackOrder)trackOrder
                       titleKeyPath:(NSString *)titleKeyPath
                      artistKeyPath:(NSString *)artistKeyPath
{
    return [[self alloc] initWithRequestURL:requestURL
                             responseFormat:responseFormat
                                 trackOrder:trackOrder
                               titleKeyPath:titleKeyPath
                              artistKeyPath:artistKeyPath];
}

#pragma mark - Public methods

#pragma mark - Debug

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> - Request URL : %@ Response format : %d Track order : %d Title key path : %@ Artist key path : %@", self.class, self, self.requestURL, self.responseFormat, self.trackOrder, self.titleKeyPath, self.artistKeyPath];
}

#pragma mark - Helper methods

- (ROKRequestResponseFormat)responseFormatForString:(NSString *)string
{
    static NSDictionary *mapping;
    if (!mapping)
    {
        mapping = @{
                    @"xml" : @(ROKRequestResponseFormatXML),
                    @"json" : @(ROKRequestResponseFormatJSON),
                    };
    }
    return [mapping[string] integerValue] ?: ROKRequestResponseFormatJSON;
}

- (ROKRadioTrackOrder)trackOrderForString:(NSString *)string
{
    static NSDictionary *mapping;
    if (!mapping)
    {
        mapping = @{
                    @"asc" : @(ROKRadioTrackOrderAsc),
                    @"desc" : @(ROKRadioTrackOrderDesc),
                    };
    }
    return [mapping[string] integerValue] ?: ROKRadioTrackOrderAsc;
}

@end

@implementation ROKRadio (ROKKeyValue)

+ (instancetype)radioWithDictionary:(NSDictionary *)dictionary
{
    ROKRadio *radio = [[ROKRadio alloc] init];
    
    NSArray *keys = dictionary.allKeys;
    for (NSString *key in keys)
    {
        NSError *error;
        id value = dictionary[key];
        BOOL validated = [radio validateValue:&value forKey:key error:&error];
        if (validated)
        {
            [radio setValue:value forKey:key];
        }
    }
    return radio;
}

- (BOOL)validateResponseFormat:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if ([(*ioValue) isKindOfClass:[NSString class]])
    {
        (*ioValue) = @([self responseFormatForString:(*ioValue)]);
        return YES;
    }
    
    return NO;
}

- (BOOL)validateTrackOrder:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    if ([(*ioValue) isKindOfClass:[NSString class]])
    {
        (*ioValue) = @([self trackOrderForString:(*ioValue)]);
        return YES;
    }
    
    return NO;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    return;
}

@end

@implementation ROKRadio (ROKRequest)

- (void)lastTracks:(ROKRadioLastTracksBlock)completion
{
    NSParameterAssert(completion);
    
    ROKRequest *request = [ROKRequest requestWithParameter:self];
    [request perform:^(NSArray *results, NSError *error) {
        if (self.trackMappingClass)
            results = [self mapRawTracksToObjects:results];
        completion(request, results, error);
    }];
}

- (void)lastTrack:(ROKRadioLastTrackBlock)completion
{
    NSParameterAssert(completion);
    
    [self lastTracks:^(ROKRequest *request, NSArray *tracks, NSError *error) {
        ROKRadioTrackOrder trackOrder = self.trackOrder ?: ROKRadioTrackOrderAsc;
        id lastTrack = trackOrder == ROKRadioTrackOrderAsc ? tracks.firstObject : tracks.lastObject;
        completion(request, lastTrack, error);
    }];
}

@end

@implementation ROKRadio (ROKMapping)

- (Class<ROKTrack>)trackMappingClass
{
    return _trackMappingClass;
}

- (void)setTrackMappingClass:(Class<ROKTrack>)trackMappingClass
{
    _trackMappingClass = trackMappingClass;
}

- (NSArray *)mapRawTracksToObjects:(NSArray *)objects
{
    if (!_trackMappingClass || ![_trackMappingClass conformsToProtocol:@protocol(ROKTrack)])
        return objects;
    
    NSMutableArray *mappedTracks = [NSMutableArray arrayWithCapacity:objects.count];
    for (NSDictionary *track in objects)
    {
        id<ROKTrack> mappedTrack = [[_trackMappingClass alloc] init];
        mappedTrack.title = track[kROKRequestTitleKey];
        mappedTrack.artist = track[kROKRequestArtistKey];
        [mappedTracks addObject:mappedTrack];
    }
    
    return mappedTracks;
}

@end
