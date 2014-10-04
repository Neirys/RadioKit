//
//  ROKRadio.h
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

#import <Foundation/Foundation.h>

#import "ROKRequest.h"

@protocol ROKRequestParameter, ROKTrack;

typedef ROKRequestResponseFormat ROKRadioResponseFormat;

typedef void (^ROKRadioLastTracksBlock) (ROKRequest *request, NSArray *tracks, NSError *error);
typedef void (^ROKRadioLastTrackBlock) (ROKRequest *request, id<ROKTrack> track, NSError *error);

typedef NS_ENUM(NSUInteger, ROKRadioTrackOrder)
{
    ROKRadioTrackOrderAsc,
    ROKRadioTrackOrderDesc,
};

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
 *  A `ROKRadio` object is backed by a `ROKRequest` object which is the one performing requests.
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
