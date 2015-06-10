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


@interface SASImageViewController () <SASMapViewNotifications ,UIScrollViewDelegate> {
    DeviceType deviceType;
}

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UITextView *photoDescription;
@property (nonatomic, strong) UIImage *sasImage;
@property (nonatomic, weak) IBOutlet SASImageView *sasImageView;
@property (nonatomic, strong) SASActivityIndicator *sasActivityIndicator;

@property (nonatomic, strong) IBOutlet SASMapView *sasMapView;

@property (nonatomic, weak) IBOutlet UIImageView *deviceImageView;

@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@property (nonatomic, weak) IBOutlet UIButton *showDeviceLocationPin;

@end

@implementation SASImageViewController

@synthesize annotation;

@synthesize scrollView;

// This property is the image which has been fetched from
// the server getSASImageWithURLFromString:
@synthesize sasImage;

@synthesize sasImageView;
@synthesize sasMapView;
@synthesize photoDescription;
@synthesize deviceImageView;
@synthesize contentView;
@synthesize sasActivityIndicator;
@synthesize distanceLabel;
@synthesize showDeviceLocationPin;

- (void)viewDidLoad {
    [super viewDidLoad];
}




- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;

    self.tabBarController.tabBar.hidden = YES;


#pragma Setup of the UI Elements.
    
    // @Discussion:
    //  It is possible sone properties of annotation
    //  may be nil. Check each property
    //  of annoation for nil and then
    //  update the UI accordingly.
    
    // Store the type of device shown in the image
    deviceType = annotation.device.type;
    
    // Set the content size for the scroll view.
    [self.scrollView setFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
    [self.scrollView setContentSize:CGSizeMake([Screen width], 1000)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    
    // Get the appropriate device name.
    NSString *deviceName = [Device deviceNames ][deviceType];
    self.navigationController.navigationBar.topItem.title = deviceName;
    
    
    // The sasMapView property should show the location
    // of where the device is located.
    self.sasMapView.showAnnotations = YES;
    self.sasMapView.notificationReceiver = self;
    self.sasMapView.userInteractionEnabled = YES;
    self.sasMapView.zoomToUsersLocationInitially = NO;
    self.sasMapView.showsUserLocation = NO;
    [self.sasMapView setMapType:MKMapTypeHybrid];
    [self showDeviceLocation:nil];
    
    
    
#pragma self.annotation.device nil checking
    if (self.annotation.device != nil) {
        
        // Set the image for deviceImageView associated with the device
        self.deviceImageView.image = [self deviceImageForAnnotation:self.annotation.device];
        
        // Set the elements of the UI which are coloured to the
        // respective colour associated with the device.
        [self setColourForColouredUIElements:self.annotation.device];
    }
        
    
#pragma self.annotation.device.imageStandardRes nil checking. (Image)
    if(self.annotation.device.imageStandardRes != nil) {
        
        // Begin animation of sasActivityIndicator until image is loaded.
        self.sasActivityIndicator = [[SASActivityIndicator alloc] init];
        [self.sasImageView addSubview:sasActivityIndicator];
        self.sasActivityIndicator.center = self.sasImageView.center;
        self.sasActivityIndicator.backgroundColor = [UIColor clearColor];
        [self.sasActivityIndicator startAnimating];
        
        // Set the image from the URLString contained within the device property
        // of the annotation passed to this object.
        // NOTE: The URLString is contained inside the device.standard_resolution property.
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage* imageFromURL = [self getSASImageWithURLFromString:annotation.device.imageStandardRes];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                self.sasImageView.contentMode = UIViewContentModeScaleAspectFit;
                self.sasImageView.image = imageFromURL;
                [self.sasActivityIndicator stopAnimating];
                [self.sasActivityIndicator removeFromSuperview];
                self.sasActivityIndicator = nil;
            });
        });
    }
    
    
#pragma self.annotatio.device.caption nil checking
    if(self.annotation.device.caption != nil) {
        // Set the text description of the photo.
        self.photoDescription.text = [NSString stringWithFormat:@"%@", annotation.device.caption];
        [self.photoDescription setFont:[UIFont fontWithName:@"Avenir Next" size:18]];
        [self.photoDescription sizeToFit];
        [self.photoDescription.layer setBorderWidth:0.0];
    }
}



// Shows the location of the device on the map.
- (IBAction)showDeviceLocation:(id)sender {
    [self.sasMapView showAnnotation:self.annotation andZoom:YES animated:YES];
}




// Sets all the UIElements of this view, whose colour
// is dependant on the device being shown in the image.
- (void) setColourForColouredUIElements:(Device*) device {
    NSArray* mapPinButtonImages = @[[UIImage imageNamed:@"MapPinAEDRed"],
                                    [UIImage imageNamed:@"MapPinLifeRingRed"],
                                    [UIImage imageNamed:@"MapPinFAKitGreen"],
                                    [UIImage imageNamed:@"MapPinHydrantBlue"]];
    [self.showDeviceLocationPin setImage:mapPinButtonImages[deviceType] forState:UIControlStateNormal];
    
    self.distanceLabel.textColor = [SASColour getSASColours][deviceType];
    
    // Navigation Bar.
    [self.navigationController.navigationBar setTintColor:[SASColour getSASColours][deviceType]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [SASColour getSASColours][deviceType],
                              NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.0f]}];
    
}



// Gets the image associated with the device from
// the annotation selected on the map.
- (UIImage*) deviceImageForAnnotation: (Device*) device {
    return [Device deviceImages][device.type];
}



// Gets the image for the view from the URL
- (UIImage*) getSASImageWithURLFromString: (NSString *) string {
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:string]];
    
    // Hold reference to the image.
    self.sasImage = [UIImage imageWithData:data];
    
    return sasImage;
}



#pragma SASNotificationReceiver
- (void)sasMapViewUsersLocationHasUpdated:(CLLocationCoordinate2D)coordinate {
    double distance = [SASUtilities distanceBetween:self.annotation.coordinate and:coordinate];
    
    __weak NSString *distanceString = [NSString stringWithFormat:@"%.0fKM Approx", distance];
    self.distanceLabel.text = distanceString;
}


#pragma Share to Social Media
- (IBAction)shareToSocialMedia:(id)sender {
    if(annotation != nil) {
        [SASSocial shareToSocialMedia:self.annotation.device.caption andImage:self.sasImage target:self];
    }
}


@end
