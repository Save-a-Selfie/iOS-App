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
#import "SASAnnotation.h"

// To receive noitification from SASMapView, please reference the notificationReceiver property.
// Ideally this should be changed to the Observer Design Pattern to update registered
// observers, however, this shall do for the time being.
@protocol SASMapViewNotifications <NSObject>

@optional
- (void) authorizationStatusHasChanged: (CLAuthorizationStatus) status;

@optional
- (void) sasMapViewAnnotationTapped: (SASAnnotation*) annotation;

@optional
- (void) sasMapViewUsersLocationHasUpdated: (CLLocationCoordinate2D) coordinate;

@end




@interface SASMapView : MKMapView <MKMapViewDelegate>


// Reference this object to receive appropriate method calls for
//      @protocol SASMapViewNotifications. 
@property (nonatomic, weak) id<SASMapViewNotifications> notificationReceiver;



// Shows the annotations on the map according to their coordinated.
@property(nonatomic, assign) BOOL showAnnotations;


// Calling this will bring you to the current user's location, on the map.
- (void) locateUser;



// Call this to show a single annotation on the SASMapView.
// Calling this method will set showsCurrentUserLocation to NO;
// All other annotations except for the one passed within this
// method call will be shown.
//
// @param: annotation: The annotation to show on the map.
// @param: andZoom: Zoom the coordinate of the annotation.
// @param: animated: Animate when zooming to region/ location.
- (void) showAnnotation:(SASAnnotation*) annotation andZoom:(BOOL) zoom animated:(BOOL) animated;




@end
