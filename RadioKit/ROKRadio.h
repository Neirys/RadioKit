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

typedef NS_ENUM(NSUInteger, ROKRadioTrackOrder)
{
    ROKRadioTrackOrderAsc,
    ROKRadioTrackOrderDesc,
};

@protocol ROKRequestParameter;

@protocol ROKRadio <ROKRequestParameter>

@property (assign, nonatomic) ROKRadioTrackOrder trackOrder;

@end

@interface ROKRadio : NSObject <ROKRadio>

@property (copy, nonatomic) NSString *requestURL;
@property (copy, nonatomic) NSString *titleKeyPath;
@property (copy, nonatomic) NSString *artistKeyPath;
@property (assign, nonatomic) ROKRadioTrackOrder trackOrder;
@property (assign, nonatomic) ROKRadioResponseFormat responseFormat;


+ (instancetype)radioWithRequestURL:(NSString *)requestURL
                     responseFormat:(ROKRequestResponseFormat)responseFormat
                         trackOrder:(ROKRadioTrackOrder)trackOrder
                       titleKeyPath:(NSString *)titleKeyPath
                      artistKeyPath:(NSString *)artistKeyPath;

+ (instancetype)radioWithDictionary:(NSDictionary *)dictionary;

@end
