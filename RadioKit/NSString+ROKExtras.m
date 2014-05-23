//
//  NSString+NPAdditions.m
//  Now Playing
//
//  Created by Yaman JAIOUCH on 25/04/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import "NSString+ROKExtras.h"

@implementation NSString (ROKExtras)

- (NSString *)noAccentString
{
    return [[NSString alloc] initWithData:[self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
}

- (NSString *)lowercaseAndNoAccentString
{
    return [[self noAccentString] lowercaseString];
}

@end
