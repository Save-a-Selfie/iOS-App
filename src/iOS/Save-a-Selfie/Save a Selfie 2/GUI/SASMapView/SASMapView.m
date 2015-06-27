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
    BOOL userAlreadyLocated;
}


@property(strong, nonatomic) SASLocation* sasLocation;

// Object to retrieve annotations from the server.
@property(strong, nonatomic) SASMapAnnotationRetriever *sasAnnotationRetriever;

// The annotation type for the map to show.
@property(assign, nonatomic) DeviceType annotationTypeToShow;

@property(strong, nonatomic) NSMutableArray *annotationInfoFromServer;

@end




@implementation SASMapView

@synthesize sasLocation;
@synthesize sasAnnotationRetriever;
@synthesize notificationReceiver;
@synthesize annotationInfoFromServer;
@synthesize sasAnnotationImage;
@synthesize annotationTypeToShow;
@synthesize showAnnotations;
@synthesize zoomToUsersLocationInitially;


#pragma Object Life Cycle
- (instancetype) initWithFrame:(CGRect)frame {
    
    if(self == [super initWithFrame:frame]) {
        [self setupMapView];
    }
    return self;
}


- (instancetype)init {
    if(self = [super init]) {
        [self setupMapView];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self setupMapView];
    }
    return self;
}



// Sets up the SASMapView with the appropriate properties.
- (void) setupMapView {
    
    userAlreadyLocated = NO;
    sasAnnotationImage = Default;
    annotationTypeToShow = All;
    
    self.mapType = MKMapTypeSatellite;
    
    self.delegate = self;
    self.showAnnotations = YES;
    
    // Our location object.
    self.sasLocation = [[SASLocation alloc] init];
    self.sasLocation.delegate = self;
    
    // Our annotationRetriever Object
    self.sasAnnotationRetriever = [[SASMapAnnotationRetriever alloc] init];
    self.sasAnnotationRetriever.delegate = self;
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

// @Discussion
//  By calling -removeExistingAnnotationsFromMapView and then calling
//  -plotAnnotationsWithDeviceInformation the following method
//  from MKMapViewDelegate -mapView:viewForAnnotation: is called.
//  This reloads all of the current annotations we have fetched from the server.
- (void)reloadAnnotations {
    // Remove the current annotations on the map.
    [self removeExistingAnnotationsFromMapView];
    
    
    // Call plotAnnotationsWithDeviceInformation:
    // which will do the checking on whether or not
    // that annotation should be shown on the map.
    [self plotAnnotationsWithDeviceInformation:annotationInfoFromServer];
}


// Filters the map view and shows only one type of
// annotation on the map view.
- (void)filterAnnotationsForDeviceType:(DeviceType)type {
    
    switch (type) {
        case All:
            annotationTypeToShow = All;
            break;
            
        case Defibrillator:
            annotationTypeToShow = Defibrillator;
            break;
            
        case LifeRing:
            annotationTypeToShow = LifeRing;
            break;
            
        case FirstAidKit:
            annotationTypeToShow = FirstAidKit;
            break;
            
        case FireHydrant:
            annotationTypeToShow = FireHydrant;
            break;
            
        default:
            break;
    }
    
    [self reloadAnnotations];
}


- (void)filterAnnotationsForMultipleDevices:(NSMutableArray *)devices {
}


// Zooms to a region on the map view.
- (void) zoomToCoordinates:(CLLocationCoordinate2D) coordinates animated:(BOOL) animated{
    float zoomTo = 0.003 * 0.3;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(zoomTo, zoomTo);
    
    [self setRegion: MKCoordinateRegionMake(coordinates, span) animated:animated];

}


#pragma Add & Remove MKAnnotation to MapView.
// Removes any existing annotations.
- (void) removeExistingAnnotationsFromMapView {
    for(id<MKAnnotation> annotation in self.annotations) {
        [self removeAnnotation:annotation];
    }
}



#pragma SASLocation delegate method
- (void) locationDidUpdate:(CLLocationCoordinate2D)location {
   
    currentLocation = location;
    
    if(zoomToUsersLocationInitially) {
        // We only want the map to zoom the user
        // when it is first opened. We check `userAlreadyLocated`
        // so the map does no keep zooming every time the user's
        // location is updated.
        if (!userAlreadyLocated) {
            [self locateUser];
            userAlreadyLocated = YES;
        }
    }
    
    // As the map view is providing a wrapper for the location object
    // pass on the location update of the user.
    if (notificationReceiver != nil && [notificationReceiver respondsToSelector:@selector(sasMapViewUsersLocationHasUpdated:)]) {
        [self.notificationReceiver sasMapViewUsersLocationHasUpdated:location];
    }
}



// @Discussion:
//  The following method locationPermssionsHaveChanged:(CLAuthorizationStatus) is a protocol method from
//  SASLocationDelegate. However, any object who holds a SASMapView shouldn't need to adobt the SASLocation
//  delegate as it's SASMapView they should only really be interested in. So when this object(SASMapView) gets
//  an update from SASLocation about authorization changes for location services, we simply forward them onto
//  any object who wants to receive said notifications. This makes a nice object that updates, adoptees of location
//  and map changes.
- (void) locationPermissionsHaveChanged:(CLAuthorizationStatus)status {
    if(notificationReceiver != nil && [notificationReceiver respondsToSelector:@selector(authorizationStatusHasChanged:)]) {
        [notificationReceiver authorizationStatusHasChanged:status];
    }
}



#pragma SASMapAnnotationRetrieverDelegate method
- (void) sasAnnotationsRetrieved:(NSMutableArray *)devices {
    
    if(self.annotationInfoFromServer == nil) {
        self.annotationInfoFromServer = [[NSMutableArray alloc] initWithArray:devices];
    }
    
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
    
    for (SASDevice *d in devices) {
        
        SASAnnotation *annotation = [[SASAnnotation alloc] initAnnotationWithDevice:d
                                                                            index:deviceNumber];
        deviceNumber++;
        
        // Checks whether or not that particular annotation
        // should be shown on the map. This could be due to the
        // user filtering specific annotations.
        if ([self returnForAnnotationDeviceType:d.type]) {
            [self addAnnotation:annotation];
        }
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
    
    // When -didSelectAnnotationView is fired, the annotation will always be marked
    // as `selected` and the user will not be able to select it again, until a new
    // annotation is selected. We must manually unselected it ourselfs.
    [self deselectAnnotation:view.annotation animated:YES];
}




#pragma viewForAnnotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(SASAnnotation*)annotation {
    
    static NSString *annotationViewID = @"MyLocation";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:annotationViewID];
    }
    
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        mapView.showsUserLocation = YES;
        mapView.userLocation.title = @"You are here";
        return nil;
    }
    
    
    // If we're to show the default image for the annotation
    if(sasAnnotationImage == Default) {
        return nil;
    }
    else {
        
        annotationView.image = [SASDevice deviceAnnotationImages][annotation.device.type];
        annotationView.annotation = annotation;
        annotationView.enabled = YES;
        annotationView.canShowCallout = NO;
        return annotationView;
    }
}



// @Discussion:
// Call this method to check whether or not the -mapView:viewForAnnotation: should return
// an MkAnnotationView. If SASMapView's -filterAnnotationsForType: has been called,
// then the annoatations shown are custom, therefore we must check the
// appropriate return.
- (BOOL) returnForAnnotationDeviceType:(DeviceType) deviceType {
    if (annotationTypeToShow == deviceType) {
        return YES;
    }
    else if(annotationTypeToShow == All) {
        return YES;
    }
    else {
        return NO;
    }
}



@end