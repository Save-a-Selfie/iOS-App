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
#import "SASFilterView.h"

@interface SASMapViewController () <SASImagePickerDelegate, SASFilterViewDelegate>

@property(nonatomic, strong) IBOutlet SASMapView* sasMapView;

@property(nonatomic, strong) SASImagePickerViewController *sasImagePickerController;
@property(nonatomic, strong) SASUploadImageViewController *sasUploadImageViewController;
@property(nonatomic, strong) UINavigationController *uploadImageNavigationController;

@property(strong, nonatomic) AlertBox* permissionsBox;

@property(strong, nonatomic) SASFilterView *sasFilterView;

@end

@implementation SASMapViewController

NSString *permissionsProblemOne = @"Please enable location services for this app. Launch the iPhone Settings app to do this. Go to Privacy > Location Services > Save a Selfie > While Using the App. You have to go out of this app, using the 'Home' button.";
NSString *permissionsProblemTwo = @"Please enable location services on your phone. Launch the iPhone Settings app to do this. Go to Privacy > Location Services > On. You have to go out of this app, using the 'Home' button.";

@synthesize sasMapView;
@synthesize permissionsBox;
@synthesize sasImagePickerController;
@synthesize sasUploadImageViewController;
@synthesize uploadImageNavigationController;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = NO;
    

    // Receive updates i.e location permission changes etc.
    // See SASMapView's: @protocol SASMapViewNotifications
    // for all available botifications.
    self.sasMapView.notificationReceiver = self;
    self.sasMapView.showAnnotations = YES;
    self.sasMapView.showsUserLocation = YES;
    self.sasMapView.zoomToUsersLocationInitially = YES;
    self.sasMapView.sasAnnotationImage = DevicePin;
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


#pragma SASFilterViewDelegate
- (void)sasFilterView:(SASFilterView *)view buttonWasPressed:(DeviceType)device {
    printf("Called");
    [self.sasFilterView animateOutOfView:self.view];
    [self.sasMapView filterAnnotationsForType:device];
    
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


- (IBAction)filterDevices:(id)sender {
    if(self.sasFilterView == nil) {
        self.sasFilterView = [[SASFilterView alloc] init];
        self.sasFilterView.delegate = self;
        self.sasFilterView.frame = CGRectMake(self.view.frame.origin.x,
                                              self.view.frame.origin.y -400,
                                              self.sasFilterView.frame.size.width,
                                              self.sasFilterView.frame.size.height);
        [self.sasMapView addSubview:self.sasFilterView];
    }

    [self.sasFilterView animateIntoView:self.sasMapView];
}


#pragma Begin Upload Routine.

// @Discussion:
//  The upload routine involves the following steps:
//
//  1. Present sasImagePickerController: Here the user can take a photo
//     of the desired device.
//
//  2. Wait for delegate method - (void)sasImagePickerController didFinishWithImage:(SASUploadImage *)image to be called.
//     This will give this object SASMapViewController, the image taken by the user.
//
//
//  3. Then the image is handed to sasUploadImageViewController, which will handle all
//     of the uploading.


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
    [self.sasImagePickerController dismissViewControllerAnimated:YES completion:^(){
        [self presentSASUploadImageViewControllerWithImage:image];
        self.sasImagePickerController = nil;
    }];
    

}


// Presents a SASUploadImageViewController via
- (void) presentSASUploadImageViewControllerWithImage:(SASUploadImage*) image {
    
    if(self.sasUploadImageViewController == nil) {

        self.sasUploadImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SASUploadImageViewController"];

    }
    
    if(self.uploadImageNavigationController == nil) {
        self.uploadImageNavigationController = [[UINavigationController alloc] initWithRootViewController:self.sasUploadImageViewController];
    }
    
    [self.sasUploadImageViewController setSasUploadImage:image];
    [self.navigationController presentViewController:self.uploadImageNavigationController animated:YES completion:nil];


}





@end
