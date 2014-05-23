//
//  NPRadioRequest.h
//  Now Playing
//
//  Created by Yaman JAIOUCH on 19/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ROKRequestCompletionBlock)(NSArray *results, NSError *error);

@protocol ROKRadio;

@interface ROKRequest : NSObject

@property (strong, nonatomic) id<ROKRadio> radio;

+ (instancetype)requestWithRadio:(id<ROKRadio>)radio;

- (void)perform:(ROKRequestCompletionBlock)completion;

@end
