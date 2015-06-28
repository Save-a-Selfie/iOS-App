//
//  SASUploadImageViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploadImageViewController.h"
#import "SASImageView.h"
#import "SASUtilities.h"

@interface SASUploadImageViewController ()

@property (strong, nonatomic) IBOutlet SASImageView *imageView;

@end

@implementation SASUploadImageViewController

@synthesize imageView;
@synthesize sasUploadImage;
@synthesize blurredImageView;



- (void)viewWillAppear:(BOOL)animated {
    
    self.imageView.image = self.sasUploadImage;
    self.blurredImageView.image = self.sasUploadImage;
    self.blurredImageView.contentMode = UIViewContentModeScaleToFill;
    [SASUtilities addSASBlurToView:self.blurredImageView];
    self.navigationController.navigationBar.topItem.title = @"Upload";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:
                                                                          [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f] }];
    
}


@end
