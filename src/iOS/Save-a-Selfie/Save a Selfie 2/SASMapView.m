//
//  SASMapView.m
//  SASMapView
//
//  Created by Stephen Fox on 25/05/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASMapView.h"
#import <MapKit/MapKit.h>
#import "Screen.h"
#import "SASLocation.h"
#import "AppDelegate.h"



@interface SASMapView() {
    CLLocationCoordinate2D currentLocation;
}

@property(strong, nonatomic) MKMapView *mapView;
@property(strong, nonatomic) SASLocation *sasLocation;
@end



@implementation SASMapView

@synthesize mapView;
@synthesize sasLocation;


- (instancetype)init {
    if(self == [super init]) {
        
        self = [super initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
        
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   [Screen width],
                                                                   [Screen height])];
        self.mapView.mapType = MKMapTypeStandard;
        
        self.sasLocation = [[SASLocation alloc] init];
        self.sasLocation.delegate = self;
        
        // If we can start location, allow user interaction with the map
        self.mapView.userInteractionEnabled = [sasLocation canStartLocating];
        self.mapView.scrollEnabled = YES;
        self.mapView.showsUserLocation = YES;
        
        [self addSubview:mapView];
        
        
    }
    return self;
}



- (void) locateUser {
    
    if([self.sasLocation checkLocationPermissions]) {
        
        [sasLocation startUpdatingUsersLocation];
        
        float z2 = 0.003 * 4.0;
        
        MKCoordinateSpan span = MKCoordinateSpanMake(z2, z2);
        [self.mapView setRegion: MKCoordinateRegionMake(currentLocation, span) animated:YES];
    }
    else {
        NSLog(@"SASMapView could not access location services.");
    }
}


- (void) locationDidUpdate:(CLLocationCoordinate2D)location {
    currentLocation = location;
    [self locateUser];
}



@end
