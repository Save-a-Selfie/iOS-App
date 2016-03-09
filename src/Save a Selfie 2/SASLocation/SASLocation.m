//
//  SASLocation.m
//  SASMapView
//
//  Created by Stephen Fox on 25/05/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASLocation.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"


@interface SASLocation() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (assign, nonatomic) CLLocationCoordinate2D currentUserLocationCoordinates;

@end

@implementation SASLocation



- (instancetype) init {
    if(self = [super init]) {
        [self setUpLocationManager];
    }
    return self;
}



- (void) setUpLocationManager {
    
    _currentUserLocationCoordinates = kCLLocationCoordinate2DInvalid;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
}




// Discussion:
//      If the user's current location has been found, then this will return
// the last location the devices has located the user at.
- (CLLocationCoordinate2D)currentUserLocation {
    [self.locationManager startUpdatingLocation];
    return self.currentUserLocationCoordinates;
}



- (void) startUpdatingUsersLocation {
    if([self canStartLocating]) {
        [self.locationManager startUpdatingLocation];
    } else {
        plog(@"Cannot update users location");
    }
}



- (void) stopUpdatingUsersLocation {
    [self.locationManager stopUpdatingLocation];
}


//TODO: Update this, quite confusing what the difference between this and -checkLocationpermissions do.

// As of iOS 8 we must call CLLocationManager requestWhenInUseAuthorization: or requestAlwaysAuthorization:
// this method call makes sure these methods are called before we begin updating users location.
- (BOOL) canStartLocating {
    
    // Must be called for ios 8
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        
        // Finally check if we have the correct permissions for location services.
        return [self checkLocationPermissions];
    }
    else {
        
        // As this is pre iOS 8 we dont need to call either
        // requestWhenInUseAuthorization: or requestAlwaysUseAuthorization:
        // so just check if we have appropriate permssions
        return [self checkLocationPermissions];
    }
}




- (BOOL) checkLocationPermissions {
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:
                NSLog(@"Location Services denied by user.");
                return NO;
                break;
                
            case kCLAuthorizationStatusRestricted:
                NSLog(@"Parental Control restricts location services");
                return NO;
                break;
                
            default:
                return YES;
                break;
        }
    }
    else {
        NSLog(@"Location Services Are disabled");
        return NO;
    }
}




#pragma mark LocationManagerDelegate methods.
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [locations lastObject];
    
    // Assign the current user location to the CurrentUserLocations.
    self.currentUserLocationCoordinates = location.coordinate;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sasLocation:locationDidUpdate:)]) {
        [self.delegate sasLocation:self locationDidUpdate:self.currentUserLocationCoordinates];
    }
}



// Forward permissions changes to delegate.
- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sasLocation:locationPermissionsHaveChanged:)]) {
        [self.delegate sasLocation:self locationPermissionsHaveChanged:status];
    }
}


- (void)beginReverseGeolocationUpdate:(CLLocationCoordinate2D)coordinates withUpdate:(void (^)(CLPlacemark *, NSError *))geoLocationUpdate {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
  CLGeocoder *geocoder = [CLGeocoder new];
  
  [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
      CLPlacemark *placemark = [placemarks objectAtIndex:0];
      geoLocationUpdate(placemark, error);
  }];
}

@end
