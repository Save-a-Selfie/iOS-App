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
}




- (void)viewWillAppear:(BOOL)animated {
    
    if(self.annotation != nil) {
        
        // Set the content size for the scroll view.
        [self.scrollView setContentSize:CGSizeMake([Screen width], 700)];
        self.scrollView.backgroundColor = [UIColor clearColor];

        
        
        // Set the image from the URLString contained within the device property
        // of the annotation passed to this object.
        // NOTE: The URLString is contained inside the device.standard_resolution property.
        self.sasImageView.image = [self getSASImageWithURLFromString:annotation.device.standard_resolution];
        
        
        self.deviceImageView.image = [self deviceImageFromAnnotation:self.annotation.device];
        self.deviceNameLabel.text = [self getDeviceName:self.annotation.device];
        
        NSLog(@"%f, %f", self.sasImage.size.height, self.sasImage.size.width);
        
        
        // Set the text description of the photo.
        self.photoDescription.text = [NSString stringWithFormat:@"%@\n%@", annotation.name, annotation.device.caption];
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


- (NSString*) getDeviceName:(Device *) fromDevice {
    NSArray *deviceNames = @[@"DEFIBRILLATOR",
                             @"LIFE RING",
                             @"FRIST AID KIT",
                             @"FIRE HYDRANT"];
    
    return deviceNames[fromDevice.typeOfObjectInt];
}




- (UIImage*) deviceImageFromAnnotation: (Device*) device {
    NSArray *deviceImageNames = @[[UIImage imageNamed:@"FAPicAttachment"],
                                  [UIImage imageNamed:@"LRPicAttachment"],
                                  [UIImage imageNamed:@"FAPicAttachment"],
                                  [UIImage imageNamed:@"FHPicAttachment"]
                                  ];
    
    NSLog(@"Device type: %d ", device.typeOfObjectInt );
    return deviceImageNames[device.typeOfObjectInt];
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
