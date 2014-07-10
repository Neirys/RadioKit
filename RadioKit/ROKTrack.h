//
//  NPTrack.h
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  `ROKTrack` protocol provide the most basic properties used to describe a radio track
 */
@protocol ROKTrack <NSObject>

@required
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *artist;

@end

/**
 *  `ROKTrack` is a class which could be used to provide object mapping when requesting for radios last played tracks
 */
@interface ROKTrack : NSObject <ROKTrack>

// The track's title
@property (copy, nonatomic) NSString *title;

// The track's artist
@property (copy, nonatomic) NSString *artist;

// Basic initializer
+ (instancetype)trackWithTitle:(NSString *)title artist:(NSString *)artist;

@end

/**
 *  `ROKCompare` category provides comparison methods
 *  These methods used Levenshtein algorithm to compare artist and title string
 *  Both artist and title should have more than 85% of matching to be considered as the same
 */
@interface ROKTrack (ROKCompare)

// Compare with title and artist string
- (BOOL)compareTrackWithTitle:(NSString *)title artist:(NSString *)artist;

// Compare with another `ROKTrack` object. This method used the previous one above.
- (BOOL)compareTrack:(ROKTrack *)track;

@end
