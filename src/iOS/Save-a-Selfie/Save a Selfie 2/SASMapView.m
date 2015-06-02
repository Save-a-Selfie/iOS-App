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
    CLLocationCoordinate2D currentLocation;
    BOOL showAnnotations;
}



@property(strong, nonatomic) SASLocation* sasLocation;

// Object to retrieve annotations from the server.
@property(strong, nonatomic) SASMapAnnotationRetriever *sasAnnotationRetriever;

// Hold key/value pair.
//      Key: NSString with the device name.
//      Value: UIImage with the corresponding value.
@property(strong, nonatomic) NSMutableDictionary* deviceAnnotations;
@property(strong, nonatomic) PopupImage* popupImage;


@end





@implementation SASMapView

@synthesize sasLocation;
@synthesize sasAnnotationRetriever;
@synthesize notificationReceiver;
@synthesize deviceAnnotations;
@synthesize popupImage;


- (instancetype) initWithFrame:(CGRect)frame {
    
    if(self == [super initWithFrame:frame]) {
        
        self.mapType = MKMapTypeSatellite;
        self.showsUserLocation = YES;
        self.pitchEnabled = [self respondsToSelector:NSSelectorFromString(@"setPitchEnabled")];
        self.delegate = self;
        [self showAnnotations:YES];
        
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
        plog(@"SASMapView could not access location services.");
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
    if(showAnnotations) {
        [self plotAnnotationsWithDeviceInformation:devices];
    }
}


- (void) showAnnotations: (BOOL) show {
    showAnnotations = show;
}



// @Discussion
//  Plots the annotations to the map using the information from sasAnnotationsRetrieved
//  which gives us the information about each device.
- (void) plotAnnotationsWithDeviceInformation: (NSMutableArray*) annotations {
    
    // Remove any existing annotations.
    for(id<MKAnnotation> annotation in self.annotations) {
        [self removeAnnotation:annotation];
    }
    
    int deviceNumber = 0;
    
    for (Device *d in annotations) {
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
    
    static NSString *AnnotationViewID = @"MyLocation";
    
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        theMapView.showsUserLocation = YES;
        theMapView.userLocation.title = @"You are here";
        return nil;
    }
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.image = annotation.image;
    annotationView.annotation = annotation;
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO;
    return annotationView;
}



@end