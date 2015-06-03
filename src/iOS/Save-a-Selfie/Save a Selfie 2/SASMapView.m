//
//  SASMapView1.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/05/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASMapView.h"
#import "SASLocation.h"
#import "SASAnnotation.h"
#import "SASMapAnnotationRetriever.h"
#import "PopupImage.h"

#import "UIView+NibInitializer.h"
#import "UIView+WidthXY.h"
#import "UIView+Alert.h"
#import "UIImage+Resize.h"

#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"


@interface SASMapView() <SASMapAnnotationRetrieverDelegate, SASLocationDelegate> {
    // This variable is gotten from the SASLocationDelegate method
    //  locationDidUpdate:
    CLLocationCoordinate2D currentLocation;
}


@property(strong, nonatomic) SASLocation* sasLocation;

// Object to retrieve annotations from the server.
@property(strong, nonatomic) SASMapAnnotationRetriever *sasAnnotationRetriever;



@end




@implementation SASMapView

@synthesize sasLocation;
@synthesize sasAnnotationRetriever;
@synthesize notificationReceiver;

@synthesize showAnnotations;



- (instancetype) initWithFrame:(CGRect)frame {
    
    if(self == [super initWithFrame:frame]) {
        
        self.mapType = MKMapTypeSatellite;
        self.showsUserLocation = YES;
        
        self.delegate = self;
        self.showAnnotations = YES;
        
        // Our location object.
        self.sasLocation = [[SASLocation alloc] init];
        self.sasLocation.delegate = self;
        
        // Our annotationRetriever Object
        self.sasAnnotationRetriever = [[SASMapAnnotationRetriever alloc] init];
        self.sasAnnotationRetriever.delegate = self;
        
    }
    return self;
}




// Locates the user's current location and
// zooms to that location.
- (void) locateUser {
    
    if([self.sasLocation checkLocationPermissions]) {
        [self zoomToCoordinates:currentLocation animated:YES];
    }
    else {
        plog(@"SASMapView could not access location services.");
    }
}




// Displays a single annotation on the map.
- (void) showAnnotation:(SASAnnotation*) annotation andZoom:(BOOL) zoom animated:(BOOL) animated{
    if(showAnnotations) {
        [self removeExistingAnnotationsFromMapView];
        self.showsUserLocation = NO;
    
        [self addAnnotation:annotation];
    }
    
    if(zoom) {
        [self zoomToCoordinates:annotation.coordinate animated:animated];
    }
}



// Zooms to a region on the map view.
- (void) zoomToCoordinates:(CLLocationCoordinate2D) coordinates animated:(BOOL) animated{
    float zoomTo = 0.003 * 0.3;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(zoomTo, zoomTo);
    
    [self setRegion: MKCoordinateRegionMake(coordinates, span) animated:animated];

}



// Removes any existing annotations.
- (void) removeExistingAnnotationsFromMapView {
    for(id<MKAnnotation> annotation in self.annotations) {
        [self removeAnnotation:annotation];
    }
}



#pragma SASLocation delegate method
- (void) locationDidUpdate:(CLLocationCoordinate2D)location {
    currentLocation = location;
    [self locateUser];
    plog(@"locationDidUpdate.");
}



// @Discussion:
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
- (void) sasAnnotationsRetrieved:(NSMutableArray *)devices {
    if(self.showAnnotations) {
        [self plotAnnotationsWithDeviceInformation:devices];
    }
}




// @Discussion
// Plots the annotations according to each device retreived from
// SASMapAnnotationRetrieverDelegate's method sasAnnotationsRetrieved:
- (void) plotAnnotationsWithDeviceInformation: (NSMutableArray*) devices {
    
    [self removeExistingAnnotationsFromMapView];
    
    int deviceNumber = 0;
    
    for (Device *d in devices) {
        SASAnnotation *annotation = [[SASAnnotation alloc] initAnnotationWithDevice:d index:deviceNumber];

        deviceNumber++;
        [self addAnnotation:annotation];
    }
}




#pragma MKMapViewDelegate
// @Discussion:
//  Here we are going to forward on the SASAnnotation which was tapped to any object conforming to SASMapViewNotifications
//  and who references notificationReceiver.
//  That object can handle what they do with the information provided by the
//  annotation.
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    SASAnnotation* selectedAnnotation = view.annotation;
    
    if(self.notificationReceiver != nil) {
        [self.notificationReceiver sasMapViewAnnotationTapped:selectedAnnotation];
    }
}





- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(SASAnnotation*)annotation {
    
    static NSString *annotationViewID = @"MyLocation";
    
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        theMapView.showsUserLocation = YES;
        theMapView.userLocation.title = @"You are here";
        return nil;
    }
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:annotationViewID];
    }
    
    annotationView.image = annotation.image;
    annotationView.annotation = annotation;
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO;
    return annotationView;
}



@end