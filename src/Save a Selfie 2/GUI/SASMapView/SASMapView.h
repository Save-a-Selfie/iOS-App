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
#import "SASDevice.h"

// Annotation type for the MapView.
typedef enum: NSUInteger {
    DefaultAnnotationImage, // Default MapView Pin provided by Apple.
    DeviceAnnotationImage // Annotation with the corresponding device image.
}SASAnnotationImage;



// To receive notification from SASMapView, please reference the notificationReceiver property.
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


// Shows the annotations on the map according to their coordinates.
// Default is YES.
@property(nonatomic, assign) BOOL showAnnotations;

// Will zoom to the users location when an SASMapView object is instansiated first.
// Default is NO.
@property(nonatomic, assign) BOOL zoomToUsersLocationInitially;

// The type of image to show for the annotations on the map.
// By default this property is DeviceAnnotationImage which shows the
// corresponding annotation image for the type of device.
// DefaultAnnotationImage is the standard image Apple provides for annotations.
@property(nonatomic, assign) SASAnnotationImage sasAnnotationImage;


// Calling this will bring you to the current user's location, on the map.
- (void) locateUser;


// Calling this method will load all the SASMapAnnotations
// from the server onto the SASMApView.
- (void) loadSASAnnotationsToMap;


// @return The location of the user.
- (CLLocationCoordinate2D) currentUserLocation;


// This can be changed to show specific annotation for the map view.
// If this isn't called all annotations will be shown by default.
// Calling this to show a specific type of annotation e.g. Defibrillator etc...
// will result in the map view only showing that type of annotation.
// Calling with DeviceType All will show all the annotations again.
- (void) filterAnnotationsForDeviceType:(SASDeviceType) type;


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
