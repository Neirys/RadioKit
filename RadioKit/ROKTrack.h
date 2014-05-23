//
//  NPTrack.h
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ROKTrackProtocol.h"

#warning Remove NSCoding
@interface ROKTrack : NSObject <ROKTrack, NSCoding>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *artist;

+ (instancetype)trackWithTitle:(NSString *)title artist:(NSString *)artist;

#warning Separate in categories
- (BOOL)matchingTrack:(ROKTrack *)track;
- (BOOL)matchingTrackWithTitle:(NSString *)title artist:(NSString *)artist;

@end