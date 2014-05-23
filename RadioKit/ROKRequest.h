//
//  NPRadioRequest.h
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ROKRequestCompletionBlock)(NSArray *results, NSError *error);

typedef NS_ENUM(NSUInteger, ROKRequestResponseFormat)
{
    ROKRequestResponseFormatJSON,
    ROKRequestResponseFormatXML,
};

@interface ROKRequest : NSObject

@property (copy, nonatomic) NSString *URL;
@property (assign, nonatomic) ROKRequestResponseFormat responseFormat;
@property (copy, nonatomic) NSString *titleKeyPath;
@property (copy, nonatomic) NSString *artistKeyPath;

- (instancetype)initWithURL:(NSString *)URL responseFormat:(ROKRequestResponseFormat)responseFormat titleKeyPath:(NSString *)titleKeyPath artistKeyPath:(NSString *)artistKeyPath;
+ (instancetype)requestWithURL:(NSString *)URL responseFormat:(ROKRequestResponseFormat)responseFormat titleKeyPath:(NSString *)titleKeyPath artistKeyPath:(NSString *)artistKeyPath;

- (void)perform:(ROKRequestCompletionBlock)completion;

@end
