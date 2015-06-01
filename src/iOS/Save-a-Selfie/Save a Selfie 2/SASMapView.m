//
//  SASMapView1.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/05/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASMapView.h"
#import "SASLocation.h"
#import "MyLocation.h"
#import "SASMapAnnotationRetriever.h"


@interface SASMapView() {
    CLLocationCoordinate2D currentLocation;
    BOOL showAnnotations;
}

@property(strong, nonatomic) SASLocation* sasLocation;
@property(strong, nonatomic) SASMapAnnotationRetriever *sasAnnotationRetriever;


@end


@implementation SASMapView

@synthesize sasLocation;
@synthesize sasAnnotationRetriever;
@synthesize notificationReceiver;

- (instancetype) initWithFrame:(CGRect)frame {
    
    if(self == [super initWithFrame:frame]) {
        
        self.mapType = MKMapTypeSatellite;
        self.showsUserLocation = YES;
        self.pitchEnabled = [self respondsToSelector:NSSelectorFromString(@"setPitchEnabled")];
        self.delegate = self;
        
        // Our location object.
        self.sasLocation = [[SASLocation alloc] init];
        self.sasLocation.delegate = self;
        
        // Our annotationRetriever Object
        self.sasAnnotationRetriever = [[SASMapAnnotationRetriever alloc] init];
        self.sasAnnotationRetriever.delegate = self;
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



#pragma SASLocation delegate method
- (void) locationDidUpdate:(CLLocationCoordinate2D)location {
    currentLocation = location;
    [self locateUser];
    printf("Updated");
}


// Discussion:
//  The following method locationPermssionsHaveChanged:(CLAuthorizationStatus) is a protocol method from
//  SASLocationDelegate. However, any object who holds a SASMapView shouldn't need to adobt the SASLocation
//  delegate as it's SASMapView they should only really be interested in. So when this object(SASMapView) gets
//  an update from SASLocation about authorization changes for location services, we simply forward them onto
//  any object who wants to receive said notifications. This makes a nice object that updates, adoptees of location
//  and map changes.
- (void) locationPermissionsHaveChanged:(CLAuthorizationStatus)status {
    if(notificationReceiver != nil) {
        [notificationReceiver authorizationStatusHasChanged:status];
    }
}



#pragma SASMapAnnotationRetrieverDelegate method
- (void) sasAnnotatonsRetrieved:(NSMutableArray *)device {
    [self plotAnnotationsPositions:device];
}



// Plots the annotations to the map
- (void) plotAnnotationsPositions: (NSMutableArray*) annotations {
    
    // Remove any existing annotations.
    for(id<MKAnnotation> annotation in self.annotations) {
        [self removeAnnotation:annotation];
    }
    
    
    for(int i = 0; i < [annotations count]; i++ ) {
        MyLocation *annotation = [[MyLocation alloc] initWithDevice: [annotations objectAtIndex:i]
                                                              index:i];
        
        [self addAnnotation:annotation];
    }
}


- (void) showAnnotations: (BOOL) show {
    showAnnotations = show;
}


@end
