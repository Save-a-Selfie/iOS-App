//
//  DeviceMapViewController.m
//

#import "DeviceMapViewController.h"
#import "Device.h"
#import "MyLocation.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"
#import "UIImage+Resize.h"
#import "PopupImage.h"
#import "UIView+NibInitializer.h"
#import "UIView+WidthXY.h"
#import "UIView+Alert.h"
#import "AlertBox.h"

@interface DeviceMapViewController ()

@end

@implementation DeviceMapViewController

NSMutableData *responseData;
NSMutableData *responseData;
NSURLConnection *connection;
CLLocationManager *locationManager;
MyLocation *specialAnnotation = nil; // may be set if one pin is singled out via mapVenue;
NSMutableArray *devices;
NSString *pin;
PopupImage *popupImage;
UIView *blocker;
NSArray *deviceNames;
NSArray *devicePins;
AlertBox *permissionsBox;
bool removingPopup = false;
extern CLLocationManager *locationManager;
extern CLLocationCoordinate2D currentLocation;
extern BOOL mappingAllowed;
extern NSString *permissionsProblem1;
extern NSString *permissionsProblem2;

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}

- (IBAction)findUser:(id)sender {
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [_mapView setShowsUserLocation:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    popupImage = [[PopupImage alloc] initWithNibNamed:nil];
    deviceNames = [[NSArray alloc] initWithObjects:@"defibrillator", @"life-ring", @"first-aid kit", @"hydrant", nil];
    devicePins = @[[UIImage imageNamed:@"defibrillator"], [UIImage imageNamed:@"lifeRing-1"], [UIImage imageNamed:@"firstAidKit"], [UIImage imageNamed:@"hydrant"]];
    //    popupImage = [[PopupImage alloc] init]; // for some reason initWithNibNamed does not work (!)
    locationManager = [[CLLocationManager alloc] init];
    responseData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:@"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/getMapData.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //	Device *d = [devices objectAtIndex:stationIndex];
    self.navigationItem.title = @"Map";
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _locateUserButton.frame = CGRectMake(screenRect.size.width - 50, screenRect.size.height - 100, _locateUserButton.frame.size.width, _locateUserButton.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated {
    plog(@"viewWillAppear");
    [super viewWillAppear:animated];
    if ([self checkPermissions]) {
        _mapView.userInteractionEnabled = YES;
        [self findUser:self];
        [self locateUser];
        _mapView.pitchEnabled = [_mapView respondsToSelector:NSSelectorFromString(@"setPitchEnabled")];
    } else {
        _mapView.userInteractionEnabled = NO;
    }
    
}

-(void)showPermissionsProblem:(NSString *)text {
    [self clearPermissionsBox];
    permissionsBox = [self.view permissionsProblem:text];
}

-(void)clearPermissionsBox { // called when returning from outside app
    if (permissionsBox) [permissionsBox removeFromSuperview]; permissionsBox = nil;
}

-(BOOL)checkPermissions {
    if([CLLocationManager locationServicesEnabled]){
        switch([CLLocationManager authorizationStatus]){
            case kCLAuthorizationStatusDenied:
                plog(@"Location services denied by user");
                [self showPermissionsProblem:permissionsProblem1]; return NO;
                break;
            case kCLAuthorizationStatusRestricted:
                plog(@"Parental controls restrict location services");
                [self showPermissionsProblem:permissionsProblem1]; return NO;
                break;
            default:return YES;
        }
    } else {
        // locationServicesEnabled is set to NO
        plog(@"Location Services Are Disabled");
        [self showPermissionsProblem:permissionsProblem2]; return NO;
    }
}

-(void) locateUser {
    // 1
    CLLocationCoordinate2D zoomLocation = currentLocation; // plog(@"here: %@", currentLocation);
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    // 3
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    // 4
    [_mapView setRegion:adjustedRegion animated:YES];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSArray *devs = [data componentsSeparatedByString:@"\n"];
    devices = [[NSMutableArray alloc] init];
    for (int n = 0; n < [devs count]; n++) {
        if ([devs[n] length] != 0) {
            Device *d = [[Device alloc] initWithInfoString:[devs objectAtIndex:n]];
            [devices insertObject:d atIndex:n];
        }
    }
    [self plotPositions];
}

- (void)plotPositions {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    int dNo = 0;
    for (Device *d in devices) {
        MyLocation *annotation = [[MyLocation alloc] initWithDevice:d index:dNo];
        dNo++;
        [_mapView addAnnotation:annotation];
    }
    _mapView.delegate=self;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    for (id<MKAnnotation> currentAnnotation in mapView.annotations) {
//        if ([currentAnnotation isEqual: specialAnnotation]) {
//            [mapView selectAnnotation:currentAnnotation animated:FALSE]; // note: must use 'FALSE'!
//        }
//    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    plog(@"didSelectAnnotationView %@", view);
    if ([view.annotation isKindOfClass:MKUserLocation.class]) { return; } // user's own location

    MyLocation *annotation = view.annotation;
    plog(@"annotation: %@", annotation.device.standard_resolution);
    [view bounceObject:15];
    // using solution at http://stackoverflow.com/questions/15241340/how-to-add-custom-view-in-maps-annotations-callouts
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        plog(@"dispatch_async 1");
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:annotation.device.standard_resolution]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            plog(@"dispatch_async 2");
            if ( data == nil ) { plog(@"nil for %@ (%@)", view, annotation.device.standard_resolution); return; }
            UIImage *image = [UIImage imageWithData:data];
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            /*
             w0:	screen width
             w1:	popup width
             w:		image width after scaling
             h0:	map height (screen height minus tab-bar height)
             h1:	popup height
             h2:	height of image + surround
             h:		image height after scaling
             h3:	text-box height plus bottom border (10px)
             h4:	text-box height
             hTab:	tab-bar height
             r:		ratio of image width to original image width
             r2:	corrected r value (if necessary)
             */
            float w0 = screenRect.size.width;
            float maxWidth = w0 * 0.8;
            float r = maxWidth / image.size.width;
            float h, w;
            if (r >= 1.0) { w = image.size.width; h = image.size.height; }
            else { w = maxWidth; h = image.size.height * r; }
            float h0 = screenRect.size.height - 20;
            float h1 = h0 * 0.85;
            float h2 = h1 * 0.67;
            float maxH = h2 - 20;
            if (h > maxH) {
                float r2 = maxH / h; h = maxH; w = r2 * w;
            }
            float w1 = w + 20;
            float h3 = h1 - h2;
            float h4 = h3 - 10;
            popupImage.imageView.image = [image resizedImage:CGSizeMake(w, h) interpolationQuality:kCGInterpolationHigh];
            popupImage.imageView.frame = CGRectMake(0, 0, w, h);
            [popupImage bringSubviewToFront:popupImage.imageView];
            [popupImage bringSubviewToFront:popupImage.xButton];
//            float pinLeft = view.frame.origin.x; // float pinTop = view.frame.origin.y;
            float popupImgLeft = (w0 - w) * 0.5 - 10; //  - pinLeft;
            float popupImgTop = (screenRect.size.height - h) * 0.1 + 10; //- 10 - pinTop;
            popupImage.frame = CGRectMake(popupImgLeft, -h0 - 20, w1, h1);
            popupImage.imageView.frame = CGRectMake(10, 10, w, h);
            popupImage.background.frame = CGRectMake(0, 0, w + 20, h + 20);
            popupImage.background.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
            popupImage.xButton.frame = CGRectMake(popupImage.imageView.image.size.width - 15, 10, 20, 30);
            popupImage.textView.frame = CGRectMake(10, popupImage.imageView.image.size.height + 20, w, h4);
            popupImage.textView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
            popupImage.textView.text = [NSString stringWithFormat:@"– %@ –\n\n%@", annotation.name, annotation.device.caption];
            [self.view addSubview:popupImage];
            [self.view bringSubviewToFront:popupImage];
            popupImage.hidden = NO;
            mapView.scrollEnabled = NO;
            mapView.zoomEnabled = NO;
            [[NSNotificationCenter defaultCenter]
             addObserver:self selector:@selector(closePopup)
             name:@"close popup"
             object:nil];
            [popupImage moveObject:popupImgTop overTimePeriod:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                plog(@"dispatch_after");
                [popupImage bounceObject:10];});
        });
    });
}

-(void)closePopup {
    plog(@"closePopup with popupImage %@", popupImage);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (!removingPopup) {
        removingPopup = true;
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             popupImage.frame = CGRectMake(popupImage.frame.origin.x, -screenRect.size.height - 20, popupImage.frame.size.width, popupImage.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 _mapView.scrollEnabled = YES;
                                 _mapView.zoomEnabled = YES;
                                 [popupImage removeFromSuperview];
                                removingPopup = false;
                             }
                         }];
    }
    [self plotPositions]; // ! important ! (don't know why)
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(MyLocation*)annotation {
    static NSString *AnnotationViewID = @"MyLocation";
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        theMapView.showsUserLocation = YES;
        theMapView.userLocation.title = @"You are here";
        return nil;
    }
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    annotationView.image = annotation.image;
    annotationView.annotation = annotation;
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO;
    return annotationView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)locateUserMethod:(id)sender {
    plog(@"locating user...");
    [self locateUser];
}
@end
