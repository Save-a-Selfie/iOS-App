//
//  SASUploadImageViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploadImageViewController.h"
#import "SASImageView.h"

@interface SASUploadImageViewController ()

@property (strong, nonatomic) IBOutlet SASImageView *imageView;

@end

@implementation SASUploadImageViewController

@synthesize imageView;
@synthesize sasUploadImage;



- (void)viewWillAppear:(BOOL)animated {
    
    self.imageView.image = self.sasUploadImage;
}


@end
