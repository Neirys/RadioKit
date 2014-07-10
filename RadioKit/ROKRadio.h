//
//  NPRadio.h
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ROKRequest.h"

typedef ROKRequestResponseFormat ROKRadioResponseFormat;

typedef void (^ROKRadioLastTracksBlock) (ROKRequest *request, NSArray *tracks, NSError *error);
typedef void (^ROKRadioLastTrackBlock) (ROKRequest *request, id track, NSError *error);

typedef NS_ENUM(NSUInteger, ROKRadioTrackOrder)
{
    ROKRadioTrackOrderAsc,
    ROKRadioTrackOrderDesc,
};

@protocol ROKRequestParameter, ROKTrack;

/**
 *  `ROKRadio` protocol conforms to `ROKRequestParameter` making objects conforming `ROKRadio`
 *  suitable to perform requests.
 *  The main difference reside on the track order, locating where is the most recent played track 
 *  in the response (top or bottom).
 *  This parameter will vary from a radio to an other.
 */
@protocol ROKRadio <ROKRequestParameter>

// Describes where the most recent track is locating in the response (first one or last one)
@property (assign, nonatomic, readonly) ROKRadioTrackOrder trackOrder;

@end


/**
 *  `ROKRadio` is a basic object type used to describe a radio entity.
 *  `ROKRadio` conforms to `ROKRadio` protocol which conforms itself to 'ROKRequestParameter` protocol
 *  making these objects suitable to perform request.
 */
@interface ROKRadio : NSObject <ROKRadio>

// See ROKRequest.h for explanations on the following properties
@property (copy, nonatomic, readonly) NSString *requestURL;
@property (copy, nonatomic, readonly) NSString *titleKeyPath;
@property (copy, nonatomic, readonly) NSString *artistKeyPath;
@property (assign, nonatomic, readonly) ROKRadioTrackOrder trackOrder;
@property (assign, nonatomic, readonly) ROKRadioResponseFormat responseFormat;


+ (instancetype)radioWithRequestURL:(NSString *)requestURL
                     responseFormat:(ROKRequestResponseFormat)responseFormat
                         trackOrder:(ROKRadioTrackOrder)trackOrder
                       titleKeyPath:(NSString *)titleKeyPath
                      artistKeyPath:(NSString *)artistKeyPath;

@end

/**
 *  The following methods are helper methods used to create `ROKRadio` request from a NSDictionary.
 *  These methods used Key-Value Coding to create objects so dictionary's keys name should have the same name of the above properties.
 *  These methods could be used to bind `ROKRadio` objects from a large set of radios data (in plist for example)
 */
@interface ROKRadio (ROKKeyValue)

+ (instancetype)radioWithDictionary:(NSDictionary *)dictionary;

@end

/**
 *  The following methods are the best way to easily retrieve last played tracks
 *  Results type are either `ROKTrack` objects by default or custom objects type if you have set the `trackMappingClass` property (see `ROKRadio (ROKMapping)` interface for more informations)
 */
@interface ROKRadio (ROKRequest)

// Returns a set of results
- (void)lastTracks:(ROKRadioLastTracksBlock)completion;

// Returns only one result
- (void)lastTrack:(ROKRadioLastTrackBlock)completion;

@end

/**
 *  The following `mappingClass` property is actually a proxy to a `ROKRequest` `mappingClass` property
 *  See `ROKRequest (ROKMapping)` interface for more informations
 */
@interface ROKRadio (ROKMapping)

@property (unsafe_unretained, nonatomic) Class<ROKTrack> mappingClass;

@end
