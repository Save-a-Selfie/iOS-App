//
//  SASUploadImage.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploadImage.h"
#import "UIImage+SASNormalizeImage.h"

@implementation SASUploadImage

@synthesize timeStamp;
@synthesize associatedDevice;
@synthesize coordinates;

- (instancetype)initWithImage:(UIImage *)image {
    
    // @Discussion:
    //  See UIImage+SASNormalizeImage.h
    // for reason on why we need to normalize
    // the image property.
    image = [image normalizedImage];
    
    if(self = [super initWithCGImage:[image CGImage]]) {}
    
    return self;
}




@end
