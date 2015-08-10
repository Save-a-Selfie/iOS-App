//
//  SASMapViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 27/05/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
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
#import "SASNotificationView.h"
#import "UIView+Animations.h"
#import "SASMapWarningAlert.h"
#import "EULAViewController.h"
#import "SASNoticeView.h"
#import "SASAlertView.h"
#import "SASTabBarController.h"


@interface SASMapViewController () <SASImagePickerDelegate, SASFilterViewDelegate, SASUploadImageViewControllerDelegate, UIAlertViewDelegate, MKMapViewDelegate> {
    CGPoint filterButtonBeforeAnimation;
    CGPoint locateUserButtonBeforeAnimtation;
    CGPoint uploadToServerButtonBeforeAnimation;
}

@property (nonatomic, strong) IBOutlet SASMapView* sasMapView;

@property (nonatomic, strong) SASImagePickerViewController *sasImagePickerController;
@property (nonatomic, strong) SASUploadImageViewController *sasUploadImageViewController;

@property (nonatomic, strong) UINavigationController *uploadImageNavigationController;



@property (strong, nonatomic) SASNoticeView* sasNoticeView;

@property (strong, nonatomic) SASFilterView *sasFilterView;
@property (weak, nonatomic) IBOutlet UIButton *showFilterViewButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadNewImageToServerButton;
@property (strong, nonatomic) IBOutlet UIButton *locateUserButton;

@property (strong, nonatomic) SASMapWarningAlert *sasMapWarningAlert;

@end

@implementation SASMapViewController

NSString *permissionsProblemOne = @"Please enable location services for this app. Launch the iPhone Settings app to do this. Go to Privacy > Location Services > Save a Selfie > While Using the App. You have to go out of this app, using the 'Home' button.";




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
    self.sasMapView.zoomToUsersLocationInitially = YES;
    self.sasMapView.sasAnnotationImage = SASAnnotationImageCustom;
    self.sasMapView.mapType = MKMapTypeHybrid;
    [self.sasMapView loadSASAnnotationsToMap];

}



- (IBAction)locateUser:(id)sender {
     [self.sasMapView locateUser];
}



-(void) locationServicesDisabledNotice:(NSString *) text {
    [self clearSASNotice];
    
    if(self.sasNoticeView == nil) {
        self.sasNoticeView = [[SASNoticeView alloc] init];
        [self.sasNoticeView setNotice:text];
        [self.sasNoticeView setTitle:@"Note"];
    }
    [self.sasNoticeView animateIntoView:self.view];
    
}



-(void) clearSASNotice { // called when returning from outside app
    if (self.sasNoticeView) {
        [self.sasNoticeView animateOutOfView];
        self.sasNoticeView = nil;
    }
}



- (IBAction) showSASFilterView:(id)sender {
    if(self.sasFilterView == nil) {
        self.sasFilterView = [[SASFilterView alloc] init];
        self.sasFilterView.delegate = self;
    }
    
    [self.sasFilterView animateIntoView:self.sasMapView];
}


#pragma mark SASFilterViewDelegate
- (void) sasFilterView:(SASFilterView *)view doneButtonWasPressedWithSelectedDeviceType:(SASDeviceType)device {
    [self.sasMapView filterAnnotationsForDeviceType:device];
    [self.sasFilterView animateOutOfView];
}


- (void) sasFilterView:(SASFilterView *)view isVisibleInViewHierarhy:(BOOL)visibility {
    
    if(visibility) {
        
        filterButtonBeforeAnimation = self.showFilterViewButton.frame.origin;
        locateUserButtonBeforeAnimtation = self.locateUserButton.frame.origin;
        uploadToServerButtonBeforeAnimation = self.uploadNewImageToServerButton.frame.origin;
        
        [UIView animateView:self.showFilterViewButton offScreenInDirection:SASAnimationDirectionRight completion:nil];
        [UIView animateView:self.locateUserButton offScreenInDirection:SASAnimationDirectionDown completion:nil];
        [UIView animateView:self.uploadNewImageToServerButton offScreenInDirection:SASAnimationDirectionDown completion:nil];
    } else {
        [UIView animateView:self.showFilterViewButton toPoint:filterButtonBeforeAnimation];
        [UIView animateView:self.locateUserButton toPoint:locateUserButtonBeforeAnimtation];
        [UIView animateView:self.uploadNewImageToServerButton toPoint:uploadToServerButtonBeforeAnimation];
    }

}



#pragma mark <SASMapViewNotifications>
- (void)sasMapView:(SASMapView *)mapView annotationWasTapped:(SASAnnotation *) annotation {
    
    // Present the SASImageviewController to display the image associated
    // with the annotation selected.
    SASImageViewController *sasImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SASImageViewController"];
    
    sasImageViewController.device = annotation.device;
    
    [self.navigationController pushViewController:sasImageViewController animated:YES];

}





// This method will be called anythime permissions for lacation is changed.
- (void)sasMapView:(SASMapView *)mapView authorizationStatusHasChanged:(CLAuthorizationStatus)status {
    
    BOOL makeCheckForMapWarning = NO;
    
    if (self.sasNoticeView) {
        [self.sasNoticeView animateOutOfView]; // get rid of any existing permissions box blocking access to camera etc.
    }
    
    if([CLLocationManager locationServicesEnabled]){
        
        switch(status){
                
            case kCLAuthorizationStatusAuthorizedAlways:
                NSLog(@"We have access to location services");
                break;
                
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"We have access to location services");
                
                makeCheckForMapWarning = YES;
                // Only when we have access to location
                // can this be set to YES.
                self.sasMapView.showsUserLocation = YES;
                break;
                
            case kCLAuthorizationStatusDenied:
                NSLog(@"Location services denied by user");
                [self locationServicesDisabledNotice:permissionsProblemOne];
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
        [self locationServicesDisabledNotice:permissionsProblemOne];
    }
    
    
    if (makeCheckForMapWarning) {
        [self makeCheckForMapWarning];
    }
    

}

#pragma Map Warning
- (void) makeCheckForMapWarning {
    
    BOOL hasMapWarningHasBeenAccepted = [[[NSUserDefaults standardUserDefaults]
                                          valueForKey:@"mapWarningAccepted"]
                                         isEqualToString:@"yes"];
    

    if (!hasMapWarningHasBeenAccepted) {
        if(self.sasMapWarningAlert == nil) {
            self.sasMapWarningAlert = [[SASMapWarningAlert alloc] initWithTitle:@"Warning!" andMessage:@"The information here is correct to the best of our knowledge, but its use is at your risk and discretion, with no liability to Save a Selfie, the developers or Apple."];
            
            self.sasMapWarningAlert.rightButtonTitle = @"Accept";
            [self.sasMapWarningAlert addActionforRightButton:@selector(acceptMapWarning) target:self];
            
            self.sasMapWarningAlert.leftButtonTitle = @"Decline";
            [self.sasMapWarningAlert addActionForLeftButton: @selector(declineMapWarning) target:self];
        }
        
        [self.sasMapWarningAlert animateIntoView:self.view];
    }
    
}

- (void) acceptMapWarning {
    
    self.sasMapView.userInteractionEnabled = YES;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"mapWarningAccepted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    EULAViewController *eulaVC = [EULAViewController new];
    [eulaVC updateEULATable];
    
   
}


- (void) declineMapWarning {
    
    // Disabled user interaction for user until they accept the map warning.
    self.sasMapView.userInteractionEnabled = NO;
    
    SASAlertView *showDisclaimerAgain = [[SASAlertView alloc] initWithTarget:self andAction:@selector(makeCheckForMapWarning)];
    showDisclaimerAgain.buttonTitle = @"Show me";
    showDisclaimerAgain.message = @"To use this app you must accept the disclaimer.";
    showDisclaimerAgain.title = @"Note";
    [showDisclaimerAgain animateIntoView:self.view];

}





#pragma mark Begin Upload Routine.

// @Discussion:
//  The upload routine involves the following steps:
//
//  1. Present sasImagePickerController: Here the user can take a photo
//     of the desired device.
//
//  2. Wait for delegate method - (void)sasImagePickerController didFinishWithImage:(UIImage *)image to be called.
//     This will give us the image taken by the user.
//     The image is then used to initialise a SASUploadObject.
//
//
//  3. Then the image is handed to sasUploadImageViewController, which will handle all
//     of the uploading.
- (IBAction)uploadNewNewDevice:(id)sender {
    

    if(self.sasImagePickerController == nil) {
        self.sasImagePickerController = [[SASImagePickerViewController alloc] init];
        self.sasImagePickerController.sasImagePickerDelegate = self;
    }

    
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.sasImagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:self.sasImagePickerController animated:YES completion:nil];
    }
}


#pragma mark SASImagePickerDelegate Method
- (void)sasImagePickerController:(SASImagePickerViewController *)sasImagePicker didFinishWithImage:(UIImage *)image {
    

    // Create an upload object and set the image.
    SASUploadObject *sasUploadObject = [[SASUploadObject alloc] initWithImage:image];
    

    
    // Dismiss the SASImagePickerViewController and pass
    // the image onto SASUploadImageViewController via
    //
    //  -presentSASUploadImageViewControllerWithImage:
    //

    [self.sasImagePickerController dismissViewControllerAnimated:YES completion:^{
        self.sasImagePickerController = nil;
        [self presentSASUploadImageViewControllerWithUploadObject:sasUploadObject];
    }];
    
}



- (void)sasImagePickerControllerDidCancel:(SASImagePickerViewController *)sasImagePickerController {
    self.sasImagePickerController = nil;
}





// Presents a SASUploadImageViewController via
- (void) presentSASUploadImageViewControllerWithUploadObject:(SASUploadObject*) sasUploadObject {
    


    // @Discussion:
    //  The user location will be got here, now it may
    //  seem like it should be gotten just before the user
    //  actually decides to upload the image/device, however,
    //  it is possible the user may take the picture and move
    //  from the location an upload moments later.
    //  So for now we will set the coordinates here.
    sasUploadObject.coordinates = [self.sasMapView currentUserLocation];
    
    
    if(self.sasUploadImageViewController == nil) {
        self.sasUploadImageViewController = (SASUploadImageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SASUploadImageViewController"];
        self.sasUploadImageViewController.delegate = self;
        [self.sasUploadImageViewController setSasUploadObject:sasUploadObject];
    }

    
    if (self.uploadImageNavigationController == nil) {
        self.uploadImageNavigationController = [[UINavigationController alloc] initWithRootViewController:self.sasUploadImageViewController];
    }
    
    [self presentViewController:self.uploadImageNavigationController animated:YES completion:nil];
    

    
}
#pragma mark SASUploadImageViewController Delegate
- (void)sasUploadImageViewControllerDidFinishUploading:(UIViewController *)viewController withResponse:(SASUploadControllerResponse)response withObject:(SASUploadObject *)sasUploadObject {
    

    // Alert the user if it was succes.
    if(response == SASUploadControllerResponseUploaded) {
        SASNotificationView *sasNotificationView = [[SASNotificationView alloc] init];
        sasNotificationView.title = @"THANK YOU!";
        sasNotificationView.image = [UIImage imageNamed:@"DoneImage"];
        [sasNotificationView animateIntoView:self.view];
    }
    

    sasUploadObject = nil;
    self.sasUploadImageViewController = nil;
    self.uploadImageNavigationController = nil;

}


@end
