//
//  SASMapView1.h
//  Save a Selfie
//
//  Created by Stephen Fox on 28/05/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SASLocation.h"


@interface SASMapView : MKMapView <SASLocationDelegate>


- (void) locateUser;


@end
