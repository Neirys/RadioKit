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

#pragma mark - Public methods

#pragma mark - Debug

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> - Request URL : %@ Response format : %d Track order : %d Title key path : %@ Artist key path : %@", self.class, self, self.requestURL, self.responseFormat, self.trackOrder, self.titleKeyPath, self.artistKeyPath];
}

#pragma mark - NSKeyValueCoding subclasses

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
