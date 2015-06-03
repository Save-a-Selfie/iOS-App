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

@interface SASImageViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITextView *photoDescription;
@property (strong, nonatomic) UIImage *sasImage;
@property (strong, nonatomic) IBOutlet UIImageView *sasImageView;

@property (strong, nonatomic) IBOutlet SASMapView *sasMapView;

@property (strong, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;

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



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the content size for the scroll view.
    [self.scrollView setContentSize:CGSizeMake([Screen width], 700)];
    
    self.scrollView.backgroundColor = [UIColor clearColor];
}




- (void)viewWillAppear:(BOOL)animated {
    
    if(self.annotation != nil) {
        
        // Add shadow to the contentView associated with the scrollView
        [self setShadowForView:self.contentView];
        
        
        // Set the image from the URLString contained within the device property
        // of the annotation passed to this object.
        // NOTE: The URLString is contained inside the device.standard_resolution property.
        self.sasImageView.image = [self getSASImageWithURLFromString:annotation.device.standard_resolution];
        
        
        // Set the image for the device associated with the image.
        self.deviceImageView.image = [self deviceImageFromAnnotation:self.annotation.device];
        
        
        // Using attributed string to increase the character spacing for deviceNameLabel
        NSString *deviceName = [self getDeviceName:self.annotation.device];
        
        NSMutableAttributedString *attributedDeviceNameLabel = [[NSMutableAttributedString alloc] initWithString:[self getDeviceName:self.annotation.device]];
        [attributedDeviceNameLabel addAttribute:NSKernAttributeName value:@(2.5)
                                          range:NSMakeRange(0, [deviceName length])];
        self.deviceNameLabel.attributedText = attributedDeviceNameLabel;
        
        
        // Set the text description of the photo.
        self.photoDescription.text = [NSString stringWithFormat:@"%@", annotation.device.caption];
        [self.photoDescription setFont:[UIFont fontWithName:@"Avenir Next" size:18]];
        
        
        // The sasMapView property should show the location
        // of where the picture was taken.
        self.sasMapView.showAnnotations = YES;
        self.sasMapView.userInteractionEnabled = YES;
        [self.sasMapView setMapType:MKMapTypeHybrid];
        [self.sasMapView showAnnotation:self.annotation
                                andZoom:YES
                               animated:NO];
        
    }
}



- (CGFloat) correctSizeForView: (UIView*) view {

    CGFloat h = 0;
    
    for (UIView* subview in view.subviews) {
        for(UIView* v in subview.subviews) {
            h += v.bounds.size.height;
            NSLog(@"%@", subview);
        }
        
        NSLog(@"%@", subview);
        h += subview.bounds.size.height;
        printf("%f\n", h);
    }
    
    return h;

}




- (void) setShadowForView: (UIView*) view {
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, -2);
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowRadius = 1.0;
    view.clipsToBounds = NO;
}



- (NSString*) getDeviceName:(Device *) fromDevice {
    NSArray *deviceNames = @[@"DEFIBRILLATOR",
                             @"LIFE RING",
                             @"FRIST AID KIT",
                             @"FIRE HYDRANT"];
    
    return deviceNames[fromDevice.typeOfObjectInt];
}




- (UIImage*) deviceImageFromAnnotation: (Device*) device {
    return [device getDeviceImages][device.typeOfObjectInt];
}





- (UIImage*) getSASImageWithURLFromString: (NSString *) string {
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:string]];
    
    UIImage *image = [UIImage imageWithData:data];
    
    // Hold reference to the image within this object.
    self.sasImage = image;
    
    return sasImage;
}


- (IBAction)dissmissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL) prefersStatusBarHidden {
    return YES;
}

@end
