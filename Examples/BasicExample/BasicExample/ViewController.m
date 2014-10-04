//
//  ViewController.m
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

#import "ViewController.h"

#import "RadioKit.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ROKRadio *voltage = [ROKRadio radioWithRequestURL:@"http://www.voltage.fr/rcs/playing.xml"
                                       responseFormat:ROKRequestResponseFormatXML
                                           trackOrder:ROKRadioTrackOrderAsc
                                         titleKeyPath:@"info.chanson"
                                        artistKeyPath:@"info.artiste"];
    [voltage lastTracks:^(ROKRequest *request, NSArray *tracks, NSError *error) {
        NSLog(@"%@", request);
        NSLog(@"%@", tracks);
        NSLog(@"%@", error);
    }];

    [voltage lastTrack:^(ROKRequest *request, id<ROKTrack> track, NSError *error) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@", track.title, track.artist];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"Now playing on Voltage FM"
                                        message:message delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil]
             show];
        });
    }];
}

@end
