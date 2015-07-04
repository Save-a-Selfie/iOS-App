//
//  SASGalleryCell.m
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryCell.h"
#import "SASMapAnnotationRetriever.h"

@interface SASGalleryCell()


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation SASGalleryCell

@synthesize sasDevice;
@synthesize imageView;




- (void)setSasDevice:(SASDevice *)aSasDevice {
    
    UIImage *image = [SASMapAnnotationRetriever getImageFromURLWithString:sasDevice.imageStandardRes];
    self.imageView.image = image;
    

}

@end
