//
//  SASLocation.h
//  SASMapView
//
//  Created by Stephen Fox on 25/05/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SASObjectDownloader.h"

@class SASLocation;

// This protocol provides a wrapper for CLLocationManagerDelegate, and enables us to retreive
// the appropriate location information needed.
@protocol SASLocationDelegate <NSObject>

- (void) sasLocation:(SASLocation *) sasLocation locationDidUpdate: (CLLocationCoordinate2D) location;

@optional
- (void) sasLocation:(SASLocation *) sasLocation locationPermissionsHaveChanged: (CLAuthorizationStatus) status;

@end


@interface SASLocation : NSObject <CLLocationManagerDelegate>


@property(assign) id<SASLocationDelegate> delegate;

/**
 Returns the last updated location of the user.
 
 @return currentUserLocation
          The last updated location of the user.
 Warning: It is possible that this could return invalid
          coordinates as the user's location may not be
          known. It would be advised to check for the validity
          of this property using -CLLocationCoordinate2DIsValid:
          for this reason.
 
 */
- (CLLocationCoordinate2D) currentUserLocation;


/**
 This method will begin updating the user's location (if it can).
 The location is passed via SASLocationDelegate -locationDidUpdate callback
 */
- (void) startUpdatingUsersLocation;


/**
 Terminates updates on the user's location via
 SASLocation delegate callback.
 */
- (void) stopUpdatingUsersLocation;


/**
 This method will check the current status of location permissions
 for the user's device.
 
 @return NO
         We don't have permission to location services.
         This could be due to the user not allowing this app to use the location
         or having location services turned off altogether.
 
         YES
         We have access to location services.
 */
- (BOOL) checkLocationPermissions;


/**
 Checks to see if we can begin location the user.
 
 @return YES
         Locating can begin.
 
         NO
         Locating cannot begin.
 */
- (BOOL) canStartLocating;

@end
