//
//  SASImageViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 02/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASImageViewController.h"
#import "SASMapView.h"
#import "Screen.h"
#import "SASColour.h"
#import "SASActivityIndicator.h"
#import "SASUtilities.h"
#import "SASSocial.h"
#import "SASImageView.h"
#import "ILTranslucentView.h"
#import "SASObjectDownloader.h"
#import "SASBarButtonItem.h"
#import "SASAlertView.h"
#import "UIFont+SASFont.h"



@interface SASImageViewController () <SASMapViewNotifications ,UIScrollViewDelegate> {
    BOOL imageLoaded;
}

@property (nonatomic, assign) SASDeviceType sasDeviceType;


@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UITextView *photoDescription;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, weak) IBOutlet SASImageView *sasImageView;
@property (strong, nonatomic) IBOutlet SASImageView *blurredImageView;

@property (nonatomic, strong) SASActivityIndicator *sasActivityIndicator;

@property (nonatomic, strong) IBOutlet SASMapView *sasMapView;

@property (nonatomic, weak) IBOutlet UIImageView *deviceImageView;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@property (nonatomic, weak) IBOutlet UIButton *showDeviceLocationPin;

@property (nonatomic, strong) SASObjectDownloader *sasObjectDownloader;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoDesriptionHeightContraint;
@end

@implementation SASImageViewController

@synthesize annotation;
@synthesize scrollView;
@synthesize sasDeviceType;

@synthesize sasImageView;
@synthesize blurredImageView;
@synthesize sasMapView;
@synthesize photoDescription;
@synthesize deviceImageView;
@synthesize contentView;
@synthesize separator;
@synthesize sasActivityIndicator;
@synthesize distanceLabel;
@synthesize showDeviceLocationPin;
@synthesize photoDesriptionHeightContraint;
@synthesize sasObjectDownloader;


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.sasMapView = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}


- (void)viewDidLayoutSubviews {
    
    self.photoDescription.translatesAutoresizingMaskIntoConstraints = NO;
    CGSize sizeThatFitsTextView = [self.photoDescription sizeThatFits:CGSizeMake(self.photoDescription.frame.size.width, MAXFLOAT)];
    self.photoDesriptionHeightContraint.constant = sizeThatFitsTextView.height;
    
    [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height + sizeThatFitsTextView.height)];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    CGRect frame = self.separator.frame;
    frame.size.height = 0.2;
    self.separator.frame = frame;

    SASBarButtonItem *reportButton = [[SASBarButtonItem alloc] initWithTitle:@"Report"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(reportImage)];
    self.navigationItem.rightBarButtonItem = reportButton;

    
    // @Discussion:
    //  It is possible sone properties of annotation
    //  may be nil. Check each property
    //  of annoation for nil and then
    //  update the UI accordingly.
    
    // Store the type of device shown in the image
    self.sasDeviceType = self.annotation.device.type;
    
    self.scrollView.delegate = self;

    // Get the appropriate device name.
    NSString *deviceName = [SASDevice getDeviceNameForDeviceType:self.sasDeviceType];
    self.navigationController.navigationBar.topItem.title = deviceName;
    
    
    
    // The sasMapView property should show the location
    // of where the device is located.
    self.sasMapView.sasAnnotationImage = SASAnnotationImageDefault;
    self.sasMapView.notificationReceiver = self;
    self.sasMapView.userInteractionEnabled = YES;
    self.sasMapView.showsUserLocation = YES;
    [self.sasMapView setMapType:MKMapTypeHybrid];
    [self showDeviceLocation];
    
    
    
    if (self.annotation.device != nil) {
        
        // Set the image for deviceImageView associated with the device
        self.deviceImageView.image = [self deviceImageForAnnotation:self.annotation.device];
        
        // Set the elements of the UI which are coloured to the
        // respective colour associated with the device.
        [self setColourForColouredUIElements:self.annotation.device];
    }
        
    

    if(self.annotation.device.imageURL != nil && !imageLoaded) {
        
        if (self.sasActivityIndicator == nil) {
            // Begin animation of sasActivityIndicator until image is loaded.
            self.sasActivityIndicator = [[SASActivityIndicator alloc] initWithMessage:@"Loading..."];
        }
        
        [self.sasImageView addSubview:sasActivityIndicator];
        self.sasActivityIndicator.backgroundColor = [UIColor clearColor];
        self.sasActivityIndicator.center = self.sasImageView.center;
        [self.sasActivityIndicator startAnimating];
        
        // Set the image from the URLString contained within the device property
        // of the annotation passed to this object.
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            self.sasObjectDownloader = [[SASObjectDownloader alloc]init];
            UIImage* imageFromURL = [self.sasObjectDownloader getImageFromURLWithString:self.annotation.device.imageURL];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                
                // The image for the view
                self.sasImageView.image = imageFromURL;
                
                // The blurred image background view.
                self.blurredImageView.contentMode = UIViewContentModeScaleToFill;
                self.blurredImageView.image = imageFromURL;
                [SASUtilities addSASBlurToView:self.blurredImageView];
                
                [self.sasActivityIndicator stopAnimating];
                [self.sasActivityIndicator removeFromSuperview];
                self.sasActivityIndicator = nil;
                
                imageLoaded = YES;
            });
        });
    }
    
    
    

    if(self.annotation.device.caption != nil) {
        // Set the text description of the photo.
        self.photoDescription.text = [NSString stringWithFormat:@"%@", annotation.device.caption];
        [self.photoDescription setFont:[UIFont fontWithName:@"Avenir Next" size:18]];
        [self.photoDescription sizeToFit];
        [self.photoDescription.layer setBorderWidth:0.0];
        

    }
}



// Shows the location of the device on the map.
- (IBAction)showDeviceLocation {
    [self.sasMapView showAnnotation:self.annotation andZoom:YES animated:YES];
}



// Sets all the UIElements of this view, whose colour
// is dependant on the device being shown in the image.
- (void) setColourForColouredUIElements:(SASDevice*) device {
    
    
    [self.showDeviceLocationPin setImage:[SASDevice getDeviceMapPinImageForDeviceType:self.sasDeviceType]
                                forState:UIControlStateNormal];
    
    self.distanceLabel.textColor = [SASColour getSASColourForDeviceType: self.sasDeviceType];
    
    // Navigation Bar.
    [self.navigationController.navigationBar setTintColor:[SASColour getSASColourForDeviceType: self.sasDeviceType]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f],
                                                                      NSForegroundColorAttributeName : [SASColour getSASColourForDeviceType: self.sasDeviceType],
                                                                      }];
    
}


// Gets the image associated with the device from
// the annotation selected on the map.
- (UIImage*) deviceImageForAnnotation: (SASDevice*) device {
    return [SASDevice getDeviceImageForDeviceType:device.type];
}





#pragma mark SASMapNotificationReceiver
- (void)sasMapViewUsersLocationHasUpdated:(CLLocationCoordinate2D)coordinate {
    
    CLLocation *usersLocation = [[CLLocation alloc] initWithLatitude:self.annotation.coordinate.latitude longitude:self.annotation.coordinate.longitude];
    CLLocation *deviceLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLLocationDistance distance = [usersLocation distanceFromLocation:deviceLocation];
    
    NSString *distanceString = [NSString stringWithFormat:@"%.1fKM Approx", distance/1000];
    
    self.distanceLabel.text = distanceString;
}


#pragma mark Share to Social Media
- (IBAction)shareToSocialMedia:(id)sender {
    if (self.annotation.device.caption == nil || self.sasImageView.image == nil) {
        
        SASAlertView *couldNotShareAlert = [[SASAlertView alloc] initWithTarget:self andAction:nil];
        couldNotShareAlert.title = @"Oops";
        couldNotShareAlert.message = @"There seemed to be a problem trying to share the image. Please try again.";
        couldNotShareAlert.buttonTitle = @"Ok";
        [couldNotShareAlert animateIntoView:self.view];
    }
    else {
        [SASSocial shareToSocialMedia:self.annotation.device.caption
                             andImage:self.sasImageView.image target:self];
    }
}

#pragma mark Report Device
- (void) reportImage {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:
              [NSString stringWithFormat:@"http://saveaselfie.org/problem-with-an-image/?imageURL=%@", self.annotation.device.imageURL]]];
    

}




@end
