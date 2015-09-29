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
#import "SASFilterViewNew.h"
#import "Filterable.h"

@class SASMapView;

// Annotation type for the MapView.
typedef NS_ENUM(NSUInteger, SASAnnotationImage) {
    SASAnnotationImageDefault, // Annotation with the corresponding device image.
    SASAnnotationImageCustom // Default MapView Pin provided by Apple.
};



@protocol SASMapViewNotifications <NSObject>

@optional
- (void) sasMapView:(SASMapView *) mapView authorizationStatusHasChanged: (CLAuthorizationStatus) status;


- (void) sasMapView:(SASMapView *) mapView annotationWasTapped: (SASAnnotation*) annotation;


- (void) sasMapView:(SASMapView *) mapView usersLocationHasUpdated: (CLLocationCoordinate2D) coordinate;

@end




@interface SASMapView : MKMapView <MKMapViewDelegate, Filterable>


// Reference this object to receive appropriate method calls for
//      @protocol SASMapViewNotifications. 
@property (nonatomic, weak) id<SASMapViewNotifications> notificationReceiver;


/**
 Shows the annotations on the map. Default is YES.
 */
@property(nonatomic, assign) BOOL showAnnotations;


/**
 Use this flag to determine whether the mapview will zoom the the
 user's location when it is first presented.
 */
@property(nonatomic, assign) BOOL zoomToUsersLocationInitially;

/**
 The UI of the image for the annotation on the map.
 By default this property is SASAnnotationImageDefault which shows
 the default image provided by Apple.
 SASAnnotationImageCustom is the custom images for the annotation provided
 by the Save a Selfie app.
 */
@property(nonatomic, assign) SASAnnotationImage sasAnnotationImage;



/**
 Locates the user on the map.
 */
- (void) locateUser;



/**
 This method will load all the annotations from the server
 to the mapView
 */
- (void) loadSASAnnotationsToMap;


/**
 Returns the last updated location of the user.
 
 @return currentUserLocation
         The last updated location of the user.
         It is possible that this could return invalid
         coordinates as the user's location may not be
         known. It would be advised to check for the validity
         of this property using -CLLocationCoordinate2DIsValid:
         for this reason.
 
 */
- (CLLocationCoordinate2D) currentUserLocation;






/**
 This method will show a single annotation on the map view.
 This method does alter some other behaviour of the map view.
 
 - The user's location will no longer appear on the map view.
 - Only the annotation passed will be shown on the map.
 
 @param annotation
        The annotation to appear on the map.
 
 @param andZoom
        YES: Will zoom or move the map to the location of the annotation passed.
        NO: Will not zoom or move the map to the location of the annotation passed.
 
 @param animated
        If YES to zoom the zooming will be animated.
 */
- (void) showAnnotation:(SASAnnotation*) annotation andZoom:(BOOL) zoom animated:(BOOL) animated;




@end
