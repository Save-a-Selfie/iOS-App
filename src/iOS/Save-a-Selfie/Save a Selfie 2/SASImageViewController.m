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


@property (strong, nonatomic) IBOutlet UIImageView *sasImageView;

@end

@implementation SASImageViewController

@synthesize annotation;
@synthesize sasImageView;


- (void)viewDidLoad {
    [super viewDidLoad];
}




- (void)viewWillAppear:(BOOL)animated {
    
    // Set the image from the URLString contained within the device property
    // of the annotation passed to this object.
    // NOTE: The URLString is contained inside the device.standard_resolution property.
    self.sasImageView.image = [self getSASImageWithURLFromString:annotation.device.standard_resolution];
    
}




- (UIImage*) getSASImageWithURLFromString: (NSString *) string {
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:string]];
    
    UIImage *sasImage = [UIImage imageWithData:data];
    
    return sasImage;
}



@end
