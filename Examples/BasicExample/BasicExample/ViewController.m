//
//  ViewController.m
//  BasicExample
//
//  Created by Yaman JAIOUCH on 23/05/2014.
//  Copyright (c) 2014 Yaman JAIOUCH. All rights reserved.
//

#import "ViewController.h"

#import "ROKRequest.h"
#import "ROKRadio.h"
#import "ROKTrack.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ROKRadio *voltage = [ROKRadio radioWithRequestURL:@"http://www.voltage.fr/rcs/playing.xml" responseFormat:ROKRequestResponseFormatXML trackOrder:ROKRadioTrackOrderAsc titleKeyPath:@"info.chanson" artistKeyPath:@"info.artiste"];
    voltage.trackMappingClass = [ROKTrack class];
    [voltage lastTracks:^(ROKRequest *request, NSArray *tracks, NSError *error) {
        NSLog(@"%@", request);
        NSLog(@"%@", tracks);
        NSLog(@"%@", error);
    }];
}

@end
