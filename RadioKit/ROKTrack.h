//
//  ROKTrack.h
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
