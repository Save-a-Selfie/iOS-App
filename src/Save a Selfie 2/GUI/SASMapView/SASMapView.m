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
#import "SASObjectDownloader.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"


@interface SASMapView() <SASObjectDownloaderDelegate, SASLocationDelegate> {
    BOOL userAlreadyLocated;
}


// This property is gotten from the SASLocationDelegate method
//  -locationDidUpdate:
@property(assign, nonatomic) CLLocationCoordinate2D currentLocation;

@property(strong, nonatomic) SASLocation* sasLocation;

// Object to retrieve annotations from the server.
@property(strong, nonatomic) SASObjectDownloader *sasObjectDownloader;

// The annotation type for the map to show.
@property(assign, nonatomic) SASDeviceType annotationsToShow;

@property(strong, nonatomic) NSMutableArray *objectInfoFromServer;

@end




@implementation SASMapView




#pragma mark Object Life Cycle
- (instancetype) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
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
    
    self.zoomToUsersLocationInitially = NO;
    
    // This is neccessary as performing check
    // for the validity of this property requires
    // us to initialise it to kCLLocationCoordinate2DInvalid.
    _currentLocation = kCLLocationCoordinate2DInvalid;
    
    userAlreadyLocated = NO;
    self.sasAnnotationImage = SASAnnotationImageDefault;
    
    self.annotationsToShow = SASDeviceTypeAll;
    
    self.mapType = MKMapTypeSatellite;
    
    self.delegate = self;
    self.showAnnotations = YES;
    
    // Our location object.
    self.sasLocation = [[SASLocation alloc] init];
    self.sasLocation.delegate = self;
    [self.sasLocation startUpdatingUsersLocation];
    
}



- (void)loadSASAnnotationsToMap {
    // Our sasObjectDownloader Object
    self.sasObjectDownloader = [[SASObjectDownloader alloc] init];
    self.sasObjectDownloader.delegate = self;
    [self.sasObjectDownloader downloadObjectsFromServer];
}




// Locates the user's current location and
// zooms to that location.
- (void) locateUser {
    
    if([self.sasLocation checkLocationPermissions]) {
        if(CLLocationCoordinate2DIsValid(self.currentLocation)) {
            [self zoomToCoordinates:self.currentLocation animated:YES];
        }
        else {
            NSLog(@"Trying to show user's location with invalid coordinates. \n Please make sure the user's coordinates have been set correctly.\n");
        }
    }
    else {
        plog(@"SASMapView could not access location services.");
    }
}


- (CLLocationCoordinate2D) currentUserLocation {
    return self.currentLocation;
}



// Displays a single annotation on the map.
- (void) showAnnotation:(SASAnnotation*) annotation andZoom:(BOOL) zoom animated:(BOOL) animated{
    if(self.showAnnotations) {
        [self removeExistingAnnotationsFromMapView];
        self.showsUserLocation = NO;
    
        [self addAnnotation:annotation];
    }
    
    if(zoom) {
        [self zoomToCoordinates:annotation.coordinate animated:animated];
    }
}



// Filters the map view and shows only one type of
// annotation on the map view.
- (void)filterAnnotationsForDeviceType:(SASDeviceType)type {
    
    switch (type) {
        case SASDeviceTypeAll:
            self.annotationsToShow = SASDeviceTypeAll;
            break;
            
        case SASDeviceTypeDefibrillator:
            self.annotationsToShow = SASDeviceTypeDefibrillator;
            break;
            
        case SASDeviceTypeLifeRing:
            self.annotationsToShow = SASDeviceTypeLifeRing;
            break;
            
        case SASDeviceTypeFirstAidKit:
            self.annotationsToShow = SASDeviceTypeFirstAidKit;
            break;
            
        case SASDeviceTypeFireHydrant:
            self.annotationsToShow = SASDeviceTypeFireHydrant;
            break;
            
        default:
            break;
    }
    [self reloadAnnotations];
}


// Zooms to a region on the map view.
- (void) zoomToCoordinates:(CLLocationCoordinate2D) coordinates animated:(BOOL) animated{
    float zoomTo = 0.003 * 0.3;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(zoomTo, zoomTo);
    
    [self setRegion: MKCoordinateRegionMake(coordinates, span) animated:animated];

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
    [self plotAnnotationsWithObjectInformation:self.objectInfoFromServer];
}


// Removes any existing annotations.
- (void) removeExistingAnnotationsFromMapView {
    for(id<MKAnnotation> annotation in self.annotations) {
        [self removeAnnotation:annotation];
    }
}


#pragma mark SASLocation delegate method
- (void)sasLocation:(SASLocation *)sasLocation locationDidUpdate:(CLLocationCoordinate2D)location {
    self.currentLocation = location;
    
    if(self.zoomToUsersLocationInitially) {
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
    if (self.notificationReceiver != nil && [self.notificationReceiver respondsToSelector:@selector(sasMapView:usersLocationHasUpdated:)]) {
        [self.notificationReceiver sasMapView:self usersLocationHasUpdated:location];
    }
}



// @Discussion:
//  The following method locationPermssionsHaveChanged:(CLAuthorizationStatus) is a protocol method from
//  SASLocationDelegate. However, any object who holds a SASMapView shouldn't need to adobt the SASLocation
//  delegate as it's SASMapView they should only really be interested in. So when this object(SASMapView) gets
//  an update from SASLocation about authorization changes for location services, we simply forward them onto
//  any object who wants to receive said notifications. This makes a nice object that updates, adoptees of location
//  and map changes.

- (void)sasLocation:(SASLocation *)sasLocation locationPermissionsHaveChanged:(CLAuthorizationStatus)status {
    if(self.notificationReceiver != nil && [self.notificationReceiver respondsToSelector:@selector(sasMapView:authorizationStatusHasChanged:)]) {
        [self.notificationReceiver sasMapView:self authorizationStatusHasChanged:status];
    }
}



#pragma SASObjectDownloaderDelegate
- (void)sasObjectDownloader:(SASObjectDownloader *)downloader didDownloadObjects:(NSMutableArray *)objects {
    
    if(self.objectInfoFromServer == nil) {
        self.objectInfoFromServer = [[NSMutableArray alloc] initWithArray:objects];
    }
    
    if(self.showAnnotations) {
        [self plotAnnotationsWithObjectInformation:objects];
    }
}



// @Discussion
// Plots the annotations according to each object data retreived from
// SASObjectDownloaderDelegate method -sasObjectDownloader: didDownloadObjects:
- (void) plotAnnotationsWithObjectInformation: (NSMutableArray*) objectInfo {
    NSLog(@"%@", objectInfo);
    [self removeExistingAnnotationsFromMapView];
    
    for (SASDevice *device in objectInfo) {
        
        SASAnnotation *annotation = [[SASAnnotation alloc] initAnnotationWithObject:device];
        
        // Checks whether or not that particular annotation
        // should be shown on the map. This could be due to the
        // user filtering specific annotations.
        if ([self isAnnotationDeviceTypeFiltered:device.type]) {
            [self addAnnotation:annotation];
        }
    }
}




#pragma mark MKMapViewDelegate
// @Discussion:
//  Here we are going to forward on the SASAnnotation which was tapped to any object conforming to SASMapViewNotifications
//  and who references notificationReceiver.
//  That object can handle what they do with the information provided by the
//  annotation.
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    SASAnnotation* selectedAnnotation = view.annotation;
    
    if(self.notificationReceiver != nil &&
       ![selectedAnnotation isKindOfClass:MKUserLocation.class] &&
       [self.notificationReceiver respondsToSelector:@selector(sasMapView:annotationWasTapped:)]) {
        [self.notificationReceiver sasMapView:self annotationWasTapped:selectedAnnotation];
    }
    
    // When -didSelectAnnotationView is fired, the annotation will always be marked
    // as `selected` and the user will not be able to select it again, until a new
    // annotation is selected. We must manually unselected it ourselfs.
    [self deselectAnnotation:view.annotation animated:YES];
}




#pragma mark viewForAnnotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(SASAnnotation*)annotation {
    
    static NSString *annotationViewID = @"MyLocation";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:annotationViewID];
    }
    
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        return nil;
    }
    
    
    // If we're to show the default image for the annotation
    if(self.sasAnnotationImage == SASAnnotationImageDefault) {
        return nil;
    }
    else {
        annotationView.image = [SASDevice getDeviceMapAnnotationImageForDeviceType:annotation.device.type];
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
- (BOOL) isAnnotationDeviceTypeFiltered:(SASDeviceType) deviceType {
    if (self.annotationsToShow == deviceType) {
        return YES;
    }
    else if(self.annotationsToShow == SASDeviceTypeAll) {
        return YES;
    }
    else {
        return NO;
    }
}



@end