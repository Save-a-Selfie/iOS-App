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
#import "SASImagePickerViewController.h"
#import "SASUploadImageViewController.h"
#import "UIFont+SASFont.h"

@interface SASMapViewController () <SASImagePickerDelegate>

@property(nonatomic, strong) SASMapView* sasMapView;
@property(nonatomic, weak) IBOutlet UIButton *locateUserButton;
@property(nonatomic, weak) IBOutlet UIButton *addImageButton;

@property(nonatomic, strong) SASImagePickerViewController *sasImagePickerController;
@property(nonatomic, strong) SASUploadImageViewController *sasUploadImageViewController;

@property(strong, nonatomic) AlertBox* permissionsBox;

@end

@implementation SASMapViewController

NSString *permissionsProblemOne = @"Please enable location services for this app. Launch the iPhone Settings app to do this. Go to Privacy > Location Services > Save a Selfie > While Using the App. You have to go out of this app, using the 'Home' button.";
NSString *permissionsProblemTwo = @"Please enable location services on your phone. Launch the iPhone Settings app to do this. Go to Privacy > Location Services > On. You have to go out of this app, using the 'Home' button.";

@synthesize sasMapView;
@synthesize locateUserButton;
@synthesize addImageButton;
@synthesize permissionsBox;
@synthesize sasImagePickerController;
@synthesize sasUploadImageViewController;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    

    
    if(sasMapView == nil) {
        sasMapView = [[SASMapView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  [Screen width],
                                                                  [Screen height])];
        
        // Receive updates i.e location permission changes etc.
        // See SASMapView's: @protocol SASMapViewNotifications
        // for all available botifications.
        self.sasMapView.notificationReceiver = self;
        self.sasMapView.showAnnotations = YES;
        self.sasMapView.showsUserLocation = YES;
        self.sasMapView.zoomToUsersLocationInitially = YES;
        self.sasMapView.annotationType = DevicePin;
        
        [self.view addSubview:sasMapView];
        [self.view bringSubviewToFront:locateUserButton];
        [self.view bringSubviewToFront:addImageButton];
    }
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
    [self.navigationController pushViewController:sasImageViewController animated:YES];

    
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




#pragma Begin Upload Routine.

// @Discussion:
//  The upload routine involves the following steps:
//
//  1. Present sasImagePickerController: Here the user can take a photo
//     of the desired device.
//
//  2. Wait for delegate method -sasImagePickerController:(SASUploadImage*) image to be called.
//     This will give this object SASMapViewController, the image taken by the user.
//     From here we will present SASDeviceSelectionViewController so we can associate
//     a device with the image taken.
//
//  3.
- (IBAction)uploadNewNewDevice:(id)sender {
    
    if(sasImagePickerController == nil) {
        sasImagePickerController = [[SASImagePickerViewController alloc] init];
        sasImagePickerController.sasImagePickerDelegate = self;
    }
    
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [sasImagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:sasImagePickerController animated:YES completion:nil];
    }
}


#pragma SASImageDelegate Method -didFinishWithImage:(SASUploadImage*):
- (void)sasImagePickerController:(SASImagePickerViewController *)sasImagePicker didFinishWithImage:(SASUploadImage *)image {
    
    // Dismiss the SASImagePickerViewController and pass
    // the image onto SASUploadImageViewController via
    //
    //  -presentSASUploadImageViewControllerWithImage:
    //
    [self dismissViewControllerAnimated:self.sasImagePickerController
                             completion:^(){
                                 [self presentSASUploadImageViewControllerWithImage:image];
                                 self.sasImagePickerController = nil;
                             }];
}



- (void) presentSASUploadImageViewControllerWithImage:(SASUploadImage*) image {
    if(self.sasUploadImageViewController == nil) {
        
        self.sasUploadImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SASUploadImageViewController"];
    }
    [self.navigationController presentViewController:self.sasUploadImageViewController animated:YES completion:nil];


}





@end
