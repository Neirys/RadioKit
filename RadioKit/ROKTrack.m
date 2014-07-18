//
//  ROKTrack.m
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

#import "ROKTrack.h"

#import "NSString+Levenshtein.h"
#import "NSString+ROKExtras.h"

static CGFloat kROKTrackMatchingAccuracy    =   85.0;

@implementation ROKTrack

- (instancetype)initWithTitle:(NSString *)title artist:(NSString *)artist
{
    self = [super init];
    if (self)
    {
        _title = title;
        _artist = artist;
    }
    return self;
}

+ (instancetype)trackWithTitle:(NSString *)title artist:(NSString *)artist
{
    return [[self alloc] initWithTitle:title artist:artist];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class])
        return NO;
    
    ROKTrack *track = (ROKTrack *)object;

    return ([self.title.lowercaseAndNoAccentString isEqualToString:track.title.lowercaseAndNoAccentString] &&
            [self.artist.lowercaseAndNoAccentString isEqualToString:track.artist.lowercaseAndNoAccentString]);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> - title: %@ - artist: %@",
            NSStringFromClass(self.class), self, self.title, self.artist];
}

@end

@implementation ROKTrack (ROKCompare)

- (BOOL)compareTrack:(ROKTrack *)track
{
    return [self compareTrackWithTitle:track.title artist:track.artist];
}

- (BOOL)compareTrackWithTitle:(NSString *)title artist:(NSString *)artist
{
    CGFloat missingTitle = [self.title compareWithString:title matchGain:0 missingCost:1];
    CGFloat missingArtist = [self.artist compareWithString:artist matchGain:0 missingCost:1];
    CGFloat percentTitle = 100.0 - ((missingTitle / self.title.length)*100);
    CGFloat percentArtist = 100.0 - ((missingArtist / self.artist.length)*100);

    return percentTitle >= kROKTrackMatchingAccuracy && percentArtist >= kROKTrackMatchingAccuracy;
}

@end
