//
//  NPTrackProtocol.h
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ROKTrack <NSObject>

@required
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *artist;

@end
