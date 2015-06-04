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


@interface SASImageViewController () <SASMapViewNotifications> {
    int deviceType;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITextView *photoDescription;
@property (strong, nonatomic) UIImage *sasImage;
@property (strong, nonatomic) IBOutlet UIImageView *sasImageView;
@property (strong, nonatomic) SASActivityIndicator *sasActivityIndicator;

@property (strong, nonatomic) IBOutlet SASMapView *sasMapView;

@property (strong, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) IBOutlet UIButton *showDeviceLocationPin;

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
@synthesize deviceNameLabel;
@synthesize contentView;
@synthesize sasActivityIndicator;
@synthesize distanceLabel;
@synthesize showDeviceLocationPin;



- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated {
    
    if(self.annotation != nil) {
        
        // Store the type of device shown in the image
        deviceType = annotation.device.typeOfObjectInt;
        
        
        // Set the content size for the scroll view.
        [self.scrollView setContentSize:CGSizeMake([Screen width], 1000)];
        [self.scrollView setFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
        self.scrollView.backgroundColor = [UIColor clearColor];
        
        self.contentView.frame = CGRectMake(0, [Screen height] * 0.56, [Screen width], [Screen height]);

        
        // Add shadow to the contentView associated with the scrollView
        [self setShadowForView:self.contentView];
        
        
        // Set the image for the device associated with the image.
        self.deviceImageView.image = [self deviceImageFromAnnotation:self.annotation.device];
        
        
        // Begin animation of sasActivityIndicator until image is loaded.
        self.sasActivityIndicator = [[SASActivityIndicator alloc] init];
        [self.view addSubview:sasActivityIndicator];
        self.sasActivityIndicator.center = self.sasImageView.center;
        self.sasActivityIndicator.backgroundColor = [UIColor clearColor];
        [self.sasActivityIndicator startAnimating];
        
        // Set the image from the URLString contained within the device property
        // of the annotation passed to this object.
        // NOTE: The URLString is contained inside the device.standard_resolution property.
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage* imageFromURL = [self getSASImageWithURLFromString:annotation.device.standard_resolution];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                self.sasImageView.image = imageFromURL;
                [self.sasActivityIndicator stopAnimating];
                [self.sasActivityIndicator removeFromSuperview];
                self.sasActivityIndicator = nil;
            });
        });
        
        
        // Using attributed string to increase the character spacing for deviceNameLabel
        NSString *deviceName = [self.annotation.device getDeviceNames][deviceType];
        NSMutableAttributedString *attributedDeviceNameLabel = [[NSMutableAttributedString alloc] initWithString:deviceName];
        [attributedDeviceNameLabel addAttribute:NSKernAttributeName value:@(2.0)
                                          range:NSMakeRange(0, [deviceName length])];
        self.deviceNameLabel.attributedText = attributedDeviceNameLabel;
        
        
        
        // Set the text description of the photo.
        self.photoDescription.text = [NSString stringWithFormat:@"%@", annotation.device.caption];
        [self.photoDescription setFont:[UIFont fontWithName:@"Avenir Next" size:18]];
        [self.photoDescription sizeToFit];
        
        
        
        // The sasMapView property should show the location
        // of where the picture was taken.
        self.sasMapView.showAnnotations = YES;
        self.sasMapView.notificationReceiver = self;
        self.sasMapView.userInteractionEnabled = YES;
        [self.sasMapView setMapType:MKMapTypeHybrid];
        [self showDeviceLocation:nil];
        
        
        [self setColourForColouredUIElements:self.annotation.device];
        
    }
}



// Shows the location of the device on the map.
- (IBAction)showDeviceLocation:(id)sender {
    [self.sasMapView showAnnotation:self.annotation andZoom:YES animated:YES];
}




- (void) setShadowForView: (UIView*) view {
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, -2);
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowRadius = 1.0;
    view.clipsToBounds = NO;
}



// Sets all the UIElements of this view, whose colour
// is dependant on the device being shown in the image.
- (void) setColourForColouredUIElements:(Device*) device {
    NSArray* mapPinButtonImages = @[[UIImage imageNamed:@"MapPinAEDRed"],
                                    [UIImage imageNamed:@"MapPinLifeRingRed"],
                                    [UIImage imageNamed:@"MapPinFAKitGreen"],
                                    [UIImage imageNamed:@"MapPinHydrantBlue"]];
    [self.showDeviceLocationPin setImage:mapPinButtonImages[device.typeOfObjectInt] forState:UIControlStateNormal];
}



// Gets the image associated with the device.
- (UIImage*) deviceImageFromAnnotation: (Device*) device {
    return [device getDeviceImages][device.typeOfObjectInt];
}



// Gets the image for the view from the URL
- (UIImage*) getSASImageWithURLFromString: (NSString *) string {
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:string]];
    
    UIImage *image = [UIImage imageWithData:data];
    
    // Hold reference to the image within this object.
    self.sasImage = image;
    
    return sasImage;
}


#pragma SASNotificationReceiver
- (void)sasMapViewUsersLocationHasUpdated:(CLLocationCoordinate2D)coordinate {
    double distance = [SASUtilities distanceBetween:self.annotation.coordinate and:coordinate];
    NSString *distanceString = [NSString stringWithFormat:@"%.0fKM Approx", distance];
    
    self.distanceLabel.text = distanceString;
}


#pragma Share to Social Media
- (IBAction)shareToSocialMedia:(id)sender {
    if(annotation != nil) {
        [SASSocial shareToSocialMedia:self.annotation.device.caption andImage:self.sasImage target:self];
    }
}




- (IBAction)dissmissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL) prefersStatusBarHidden {
    return YES;
}

@end
