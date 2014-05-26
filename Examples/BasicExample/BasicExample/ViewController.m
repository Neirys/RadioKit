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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    ROKRequest *voltageRequest = [ROKRequest requestWithURL:@"http://www.voltage.fr/rcs/playing.xml" responseFormat:ROKRequestResponseFormatXML titleKeyPath:@"info.chanson" artistKeyPath:@"info.artiste"];
    ROKRadio *voltage = [ROKRadio radioWithRequestURL:@"http://www.voltage.fr/rcs/playing.xml" responseFormat:ROKRequestResponseFormatXML trackOrder:ROKRadioTrackOrderAsc titleKeyPath:@"info.title" artistKeyPath:@"info.artist"];
    ROKRequest *vRequest = [ROKRequest requestWithParameter:voltage];
    [vRequest perform:^(NSArray *results, NSError *error) {
        NSLog(@"%@", results);
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
