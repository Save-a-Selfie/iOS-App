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

// Annotation type for the MapView.
typedef enum: NSUInteger {
    Default, // Default MapView Pin
    DevicePin // Annotation with the corresponding device image.
}SASAnnotationImage;



// To receive noitification from SASMapView, please reference the notificationReceiver property.
// Ideally this should be changed to the Observer Design Pattern to update registered
// observers, however, this shall do for the time being.
@protocol SASMapViewNotifications <NSObject>

@optional
- (void) authorizationStatusHasChanged: (CLAuthorizationStatus) status;


- (void) sasMapViewAnnotationTapped: (SASAnnotation*) annotation;


- (void) sasMapViewUsersLocationHasUpdated: (CLLocationCoordinate2D) coordinate;

@end




@interface SASMapView : MKMapView <MKMapViewDelegate>


// Reference this object to receive appropriate method calls for
//      @protocol SASMapViewNotifications. 
@property (nonatomic, weak) id<SASMapViewNotifications> notificationReceiver;


// Shows the annotations on the map according to their coordinated.
@property(nonatomic, assign) BOOL showAnnotations;

// Will zoom to the users location SASMapView object is instansiated first.
@property(nonatomic, assign) BOOL zoomToUsersLocationInitially;


@property(nonatomic, assign) SASAnnotationImage sasAnnotationImage;


// Calling this will bring you to the current user's location, on the map.
- (void) locateUser;



// This can be changed to show specific annotation for the map view.
// If this is isn't called all annotations will be shown.
// Calling this to show a specific type of annotation e.g. Defibrillator etc...
// will result in the map view only showing that type of annotation.
// Calling with DeviceTypeAll will show all the annotations again.
- (void) filterAnnotationsForType:(DeviceType) type;



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
