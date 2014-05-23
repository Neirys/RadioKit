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
    
    ROKRadio *voltage = [ROKRadio radioWithRequestURL:@"http://www.voltage.fr/rcs/playing.xml"
                                       responseFormat:ROKRadioResponseFormatXML
                                           trackOrder:ROKRadioTrackOrderAsc
                                         titleKeyPath:@"info.chanson"
                                        artistKeyPath:@"info.artiste"];
    ROKRequest *voltageRequest = [ROKRequest requestWithRadio:voltage];
    [voltageRequest perform:^(NSArray *response, NSError *error) {
        NSLog(@"%@", response);
    }];
    
    ROKRadio *skyrock = [ROKRadio radioWithRequestURL:@"http://skyrock.fm/api-fm/schedule.php/recent.json" responseFormat:ROKRadioResponseFormatJSON trackOrder:ROKRadioTrackOrderDesc titleKeyPath:@"schedule.info.title" artistKeyPath:@"schedule.artists.name"];
    ROKRequest *skyrockRequest = [ROKRequest requestWithRadio:skyrock];
//    [skyrockRequest perform:^(NSArray *response, NSError *error) {
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
