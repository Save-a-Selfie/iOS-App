//
//  SASUploadImage.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploadObject.h"
#import "UIImage+SASImage.h"

@implementation SASUploadObject

@synthesize timeStamp;
@synthesize associatedDevice;
@synthesize coordinates;
@synthesize image;
@synthesize description;

- (instancetype)initWithImage:(UIImage *)imageToUpload {
    
    if (self = [super init]) {
        // @Discussion:
        // See UIImage+SASNormalizeImage.h
        // for reason on why we need to normalize
        // the image property.
        self.image = [imageToUpload normalizedImage];
        
        self.associatedDevice = [[SASDevice alloc] init];
    }
    return self;
}





@end
