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


@interface SASImageViewController () <SASMapViewNotifications ,UIScrollViewDelegate> {
    BOOL imageLoaded;
}

@property (nonatomic, assign) SASDeviceType sasDeviceType;


@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UITextView *photoDescription;

@property (nonatomic, strong) UIImage *sasImage;
@property (nonatomic, weak) IBOutlet SASImageView *sasImageView;
@property (strong, nonatomic) IBOutlet SASImageView *blurredImageView;

@property (nonatomic, strong) SASActivityIndicator *sasActivityIndicator;

@property (nonatomic, strong) IBOutlet SASMapView *sasMapView;

@property (nonatomic, weak) IBOutlet UIImageView *deviceImageView;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@property (nonatomic, weak) IBOutlet UIButton *showDeviceLocationPin;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoDesriptionHeightContraint;
@end

@implementation SASImageViewController

@synthesize annotation;
@synthesize scrollView;
@synthesize sasDeviceType;

// This property is the image which has been fetched from
// the server getSASImageWithURLFromString:
@synthesize sasImage;

@synthesize sasImageView;
@synthesize blurredImageView;
@synthesize sasMapView;
@synthesize photoDescription;
@synthesize deviceImageView;
@synthesize contentView;
@synthesize sasActivityIndicator;
@synthesize distanceLabel;
@synthesize showDeviceLocationPin;
@synthesize photoDesriptionHeightContraint;


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
    

#pragma mark Setup of the UI Elements.
    
    // @Discussion:
    //  It is possible sone properties of annotation
    //  may be nil. Check each property
    //  of annoation for nil and then
    //  update the UI accordingly.
    
    // Store the type of device shown in the image
    self.sasDeviceType = self.annotation.device.type;
    
    
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];

    // Get the appropriate device name.
    NSString *deviceName = [SASDevice getDeviceNameForDeviceType:self.sasDeviceType];
    self.navigationController.navigationBar.topItem.title = deviceName;
    
    
    
    // The sasMapView property should show the location
    // of where the device is located.
    self.sasMapView.sasAnnotationImage = DefaultAnnotationImage;
    self.sasMapView.notificationReceiver = self;
    self.sasMapView.userInteractionEnabled = YES;
    self.sasMapView.showsUserLocation = YES;
    [self.sasMapView setMapType:MKMapTypeHybrid];
    [self showDeviceLocation];
    
    
    
#pragma mark self.annotation.device nil checking
    if (self.annotation.device != nil) {
        
        // Set the image for deviceImageView associated with the device
        self.deviceImageView.image = [self deviceImageForAnnotation:self.annotation.device];
        
        // Set the elements of the UI which are coloured to the
        // respective colour associated with the device.
        [self setColourForColouredUIElements:self.annotation.device];

    }
        
    
#pragma mark self.annotation.device.imageStandardRes nil checking. (Image)
    if(self.annotation.device.imageStandardRes != nil && !imageLoaded) {
        
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
            
            UIImage* imageFromURL = [SASMapAnnotationRetriever getImageFromURLWithString:self.annotation.device.imageStandardRes];
            
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
    
    
    
#pragma mark self.annotation.device.caption nil checking
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





#pragma mark SASNotificationReceiver
- (void)sasMapViewUsersLocationHasUpdated:(CLLocationCoordinate2D)coordinate {
    double distance = [SASUtilities distanceBetween:self.annotation.coordinate and:coordinate];
    
    __weak NSString *distanceString = [NSString stringWithFormat:@"%.2fKM Approx", distance];
    self.distanceLabel.text = distanceString;
}


#pragma mark Share to Social Media
- (IBAction)shareToSocialMedia:(id)sender {
    if(annotation != nil) {
        [SASSocial shareToSocialMedia:self.annotation.device.caption andImage:self.sasImage target:self];
    }
}


@end
