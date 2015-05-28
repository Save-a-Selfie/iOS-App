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

// To receive noitification from SASMapView, please reference the notificationReceiver property.
// Ideally this should be changed to the Observer Design Pattern to update registered
// observers, however, this shall do for the time being.
@protocol SASMapViewNotifications

- (void) authorizationStatusHasChanged: (CLAuthorizationStatus) status;

@end


@interface SASMapView : MKMapView <SASLocationDelegate>


@property (assign) id<SASMapViewNotifications> notificationReceiver;

// Calling this will bring you to the current user's location, on the map.
- (void) locateUser;


@end
