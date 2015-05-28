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
@synthesize notificationReceiver;

- (instancetype) initWithFrame:(CGRect)frame {
    
    if(self == [super initWithFrame:frame]) {
        
        self.mapType = MKMapTypeSatellite;
        self.showsUserLocation = YES;
        self.pitchEnabled = [self respondsToSelector:NSSelectorFromString(@"setPitchEnabled")];

        
        // Our location object.
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


@end
