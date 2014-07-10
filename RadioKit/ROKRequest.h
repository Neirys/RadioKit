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

@protocol ROKTrack;

/**
 *  `ROKRequestParameter` protocol defines objects suitable to be used in order to perform a radio request
 */

@protocol ROKRequestParameter <NSObject>

@required
@property (copy, nonatomic) NSString *requestURL;
@property (assign, nonatomic) ROKRequestResponseFormat responseFormat;
@property (copy, nonatomic) NSString *titleKeyPath;
@property (copy, nonatomic) NSString *artistKeyPath;

@end

/**
 *  `ROKRequest` defines the low-level objects used to query last tracks informations
 *  All properties defines below are mandatory in order to successfully perform a request
 *  You first need to locate which URL is used by radios for fetching their last playing tracks
 *  Then, you will have to determine which are the track artist and track title key-paths of the given HTTP response
 *  Moreover, you need to determine which response format is used (usually JSON or XML)
 *
 *  Example :
 *
 *  Basic `curl` on http://www.voltage.fr/rcs/playing.xml :
 *  curl http://www.voltage.fr/rcs/playing.xml
 *
 *  Response :
 *  <xml>
 *      <info>
 *          <artiste>EMINEM</artiste>
 *          <chanson>RAP GOD</chanson>
 *      </info>
 *  </xml>
 *
 *  With this given response, we can determine that title key-path is `info.chanson` and 
 *  artist key-path is `info.artiste` (`xml` root element is ignored)
 */

@interface ROKRequest : NSObject <ROKRequestParameter>

// The URL used by radios for fetching their last playing tracks
@property (copy, nonatomic) NSString *requestURL;

// The response format the above URL (usually JSON or XML)
@property (assign, nonatomic) ROKRequestResponseFormat responseFormat;

// The response's title key-path
@property (copy, nonatomic) NSString *titleKeyPath;

// The response's artist key-path
@property (copy, nonatomic) NSString *artistKeyPath;

// Create a ROKRequest using the following mandatory parameters
- (instancetype)initWithURL:(NSString *)URL
             responseFormat:(ROKRequestResponseFormat)responseFormat
               titleKeyPath:(NSString *)titleKeyPath
              artistKeyPath:(NSString *)artistKeyPath;

// Convenience method
+ (instancetype)requestWithURL:(NSString *)URL
                responseFormat:(ROKRequestResponseFormat)responseFormat
                  titleKeyPath:(NSString *)titleKeyPath
                 artistKeyPath:(NSString *)artistKeyPath;

// Convenience method using an object conforming to `ROKRequestParameter` protocol
+ (instancetype)requestWithParameter:(id<ROKRequestParameter>)parameter;

// Execute the request asynchronously and return result in a block
// By default, request's result is an array of `ROKTrack` objects
- (void)perform:(ROKRequestCompletionBlock)completion;

@end

/**
 *  This category describes how object mapping works for track results
 *  If the `mappingClass` is set, the request methods will returns objects of type of `mappingClass`
 *  `mappingClass` type should conforms to `ROKTrack` protocol
 *  By default, `mappingClass` is set to the `ROKTrack` class, so result of `perform:` method will be an array of `ROKTrack`
 */
@interface ROKRequest (ROKMapping)

@property (unsafe_unretained, nonatomic) Class<ROKTrack> mappingClass;

@end
