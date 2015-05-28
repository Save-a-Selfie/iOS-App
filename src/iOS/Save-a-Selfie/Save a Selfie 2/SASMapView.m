//
//  SASMapView1.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/05/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASMapView.h"
#import "SASLocation.h"

@interface SASMapView() {
    CLLocationCoordinate2D currentLocation;
}

@property(strong, nonatomic) SASLocation* sasLocation;

@end


@implementation SASMapView

@synthesize sasLocation;

- (instancetype) initWithFrame:(CGRect)frame {
    
    if(self == [super initWithFrame:frame]) {
        self.mapType = MKMapTypeStandard;
        self.showsUserLocation = YES;
        
        self.sasLocation = [[SASLocation alloc] init];
        self.sasLocation.delegate = self;
    }
    return self;
}





- (void) locateUser {
    
    if([self.sasLocation checkLocationPermissions]) {
        
        float z2 = 0.003 * 4.0;
        
        MKCoordinateSpan span = MKCoordinateSpanMake(z2, z2);
        [self setRegion: MKCoordinateRegionMake(currentLocation, span) animated:YES];
    }
    else {
        NSLog(@"SASMapView could not access location services.");
    }
}





#pragma SASLocatin delegate method
- (void) locationDidUpdate:(CLLocationCoordinate2D)location {
    currentLocation = location;
    [self locateUser];
    printf("Updated");
}


@end
