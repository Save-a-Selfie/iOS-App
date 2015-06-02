//
//  SASImageViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 02/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASImageViewController.h"
#import "SASMapView.h"

@interface SASImageViewController ()

@property (strong, nonatomic) UIImage *sasImage;

@property (strong, nonatomic) IBOutlet UIImageView *sasImageView;
@property (strong, nonatomic) IBOutlet SASMapView *sasMapView;

@end

@implementation SASImageViewController

@synthesize annotation;

// This property is the image which has been fetched from
// the server getSASImageWithURLFromString:
@synthesize sasImage;

@synthesize sasImageView;
@synthesize sasMapView;


- (void)viewDidLoad {
    [super viewDidLoad];
}




- (void)viewWillAppear:(BOOL)animated {
    
    if(self.annotation != nil) {
        // Set the image from the URLString contained within the device property
        // of the annotation passed to this object.
        // NOTE: The URLString is contained inside the device.standard_resolution property.
        self.sasImageView.image = [self getSASImageWithURLFromString:annotation.device.standard_resolution];
        
        self.sasMapView.showAnnotations = YES;
        [self.sasMapView showAnnotation:self.annotation];
    }
    
    
    
}




- (UIImage*) getSASImageWithURLFromString: (NSString *) string {
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:string]];
    
    UIImage *image = [UIImage imageWithData:data];
    
    // Hold reference to the image within this object.
    self.sasImage = image;
    
    return sasImage;
}



@end
