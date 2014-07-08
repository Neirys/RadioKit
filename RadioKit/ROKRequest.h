//
//  NPRadioRequest.h
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kROKRequestTitleKey;
extern NSString * const kROKRequestArtistKey;

typedef void (^ROKRequestCompletionBlock)(NSArray *results, NSError *error);

typedef NS_ENUM(NSUInteger, ROKRequestResponseFormat)
{
    ROKRequestResponseFormatJSON,
    ROKRequestResponseFormatXML,
};

@protocol ROKRequestParameter <NSObject>

@required
@property (copy, nonatomic) NSString *requestURL;
@property (assign, nonatomic) ROKRequestResponseFormat responseFormat;
@property (copy, nonatomic) NSString *titleKeyPath;
@property (copy, nonatomic) NSString *artistKeyPath;

@end

@interface ROKRequest : NSObject <ROKRequestParameter>

@property (copy, nonatomic) NSString *requestURL;
@property (assign, nonatomic) ROKRequestResponseFormat responseFormat;
@property (copy, nonatomic) NSString *titleKeyPath;
@property (copy, nonatomic) NSString *artistKeyPath;

- (instancetype)initWithURL:(NSString *)URL
             responseFormat:(ROKRequestResponseFormat)responseFormat
               titleKeyPath:(NSString *)titleKeyPath
              artistKeyPath:(NSString *)artistKeyPath;

+ (instancetype)requestWithURL:(NSString *)URL
                responseFormat:(ROKRequestResponseFormat)responseFormat
                  titleKeyPath:(NSString *)titleKeyPath
                 artistKeyPath:(NSString *)artistKeyPath;

+ (instancetype)requestWithParameter:(id<ROKRequestParameter>)parameter;

- (void)perform:(ROKRequestCompletionBlock)completion;

@end
