//
//  NPTrack.m
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import "ROKTrack.h"

#import "NSString+Levenshtein.h"
#import "NSString+ROKExtras.h"

static NSString * const kNPTrackTitleKey    =   @"NPTrackTitleKey";
static NSString * const kNPTrackArtistKey   =   @"NPTrackArtistKey";

@implementation ROKTrack

#pragma mark - Life cycle

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

#pragma mark - NSCoding methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _title = [aDecoder decodeObjectForKey:kNPTrackTitleKey];
        _artist = [aDecoder decodeObjectForKey:kNPTrackArtistKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:kNPTrackTitleKey];
    [aCoder encodeObject:self.artist forKey:kNPTrackArtistKey];
}

#pragma mark - Public methods

- (BOOL)matchingTrack:(ROKTrack *)track
{
    return [self matchingTrackWithTitle:track.title artist:track.artist];
}

#warning Better to do string comparison ?
- (BOOL)matchingTrackWithTitle:(NSString *)title artist:(NSString *)artist
{
    CGFloat missingTitle = [self.title compareWithString:title matchGain:0 missingCost:1];
    CGFloat missingArtist = [self.artist compareWithString:artist matchGain:0 missingCost:1];
    CGFloat percentTitle = 100.0 - ((missingTitle / self.title.length)*100);
    CGFloat percentArtist = 100.0 - ((missingArtist / self.artist.length)*100);
    
#warning I'M LETTING THIS FOR A WHILE TO TEST HOW IT WORKS
    NSLog(@"title : %f / artist : %f", percentTitle, percentArtist);
    
    return percentTitle >= 85 && percentArtist >= 85;
}

#pragma mark - Comparaison object

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class])
        return NO;
    
    ROKTrack *track = (ROKTrack *)object;

    return ([self.title.lowercaseAndNoAccentString isEqualToString:track.title.lowercaseAndNoAccentString] &&
            [self.artist.lowercaseAndNoAccentString isEqualToString:track.artist.lowercaseAndNoAccentString]);
}

#pragma mark - Debug methods

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> - title: %@ - artist: %@",
            NSStringFromClass(self.class), self, self.title, self.artist];
}

@end
