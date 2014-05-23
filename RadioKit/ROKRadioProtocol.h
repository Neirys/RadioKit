//
//  NPRadioProtocol.h
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ROKRadioResponseFormat)
{
    ROKRadioResponseFormatJSON,
    ROKRadioResponseFormatXML,
};

typedef NS_ENUM(NSUInteger, ROKRadioTrackOrder)
{
    ROKRadioTrackOrderAsc,
    ROKRadioTrackOrderDesc,
};

@protocol ROKRadio <NSObject>

@required
@property (copy, nonatomic) NSString *requestURL;
@property (copy, nonatomic) NSString *titleKeyPath;
@property (copy, nonatomic) NSString *artistKeyPath;
@property (assign, nonatomic) ROKRadioTrackOrder trackOrder;
@property (assign, nonatomic) ROKRadioResponseFormat responseFormat;

@end

