//
//  SASMapViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 27/05/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASMapViewController.h"
#import "AppDelegate.h"
#import "SASImageViewController.h"
#import "ExtendNSLogFunctionality.h"
#import "Screen.h"
#import "UIView+Alert.h"

@interface SASMapViewController ()

@property(strong, nonatomic) SASMapView* sasMapView;
@property(strong, nonatomic) IBOutlet UIButton *locateUserButton;
@property(strong, nonatomic) IBOutlet UIButton *addImageButton;

@property(strong, nonatomic) AlertBox* permissionsBox;

@end

@implementation SASMapViewController

NSString *permissionsProblemOne = @"Please enable location services for this app. Launch the iPhone Settings app to do this. Go to Privacy > Location Services > Save a Selfie > While Using the App. You have to go out of this app, using the 'Home' button.";
NSString *permissionsProblemTwo = @"Please enable location services on your phone. Launch the iPhone Settings app to do this. Go to Privacy > Location Services > On. You have to go out of this app, using the 'Home' button.";

@synthesize sasMapView;
@synthesize locateUserButton;
@synthesize addImageButton;
@synthesize permissionsBox;



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    sasMapView = [[SASMapView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              [Screen width],
                                                              [Screen height])];
    // Receive updates i.e location permission changes etc.
    // See SASMapView's: @protocol SASMapViewNotifications
    // for all available botifications.
    self.sasMapView.notificationReceiver = self;
    self.sasMapView.showAnnotations = YES;
    
    [self.view addSubview:sasMapView];
    [self.view bringSubviewToFront:locateUserButton];
    [self.view bringSubviewToFront:addImageButton];

}



- (IBAction)locateUser:(id)sender {
     [self.sasMapView locateUser];
}




-(void)showPermissionsProblem:(NSString *)text {
    [self clearPermissionsBox];
    permissionsBox = [self.view permissionsProblem:text];
}



-(void)clearPermissionsBox { // called when returning from outside app
    if (permissionsBox) {
        [permissionsBox removeFromSuperview];
        permissionsBox = nil;
    }
}




#pragma SASMapViewNotifications methods.
- (void)sasMapViewAnnotationTapped:(SASAnnotation*)annotation {
    
    
    // Present the SASImageviewController to display the image associated
    // with the annotation selected.
    SASImageViewController *sasImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SASImageViewController"];
    
    sasImageViewController.annotation = annotation;
    
    [self presentViewController:sasImageViewController animated:YES completion:nil];

}




- (void) authorizationStatusHasChanged:(CLAuthorizationStatus)status {
    
    if (permissionsBox) {
        [permissionsBox removeFromSuperview]; // get rid of any existing permissions box blocking access to camera etc.
    }
    
    if([CLLocationManager locationServicesEnabled]){
        
        switch([CLLocationManager authorizationStatus]){
            
            case kCLAuthorizationStatusAuthorizedAlways:
                NSLog(@"We have access to location services");
                break;
            
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"We have access to location services");
                break;
            
            case kCLAuthorizationStatusDenied:
                NSLog(@"Location services denied by user");
                [self showPermissionsProblem:permissionsProblemOne];
                break;
            
            case kCLAuthorizationStatusRestricted:
                NSLog(@"Parental controls restrict location services");
                break;
            
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"Unable to determine, possibly not available");
                break;
        }
    }
    else {
        NSLog(@"Location Services Are Disabled");
        [self showPermissionsProblem:permissionsProblemTwo];
    }
}


@end
