//
//  SASUploadImage.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploadImage.h"

@implementation SASUploadImage

@synthesize timeStamp;
@synthesize associatedDevice;


- (instancetype)initWithImage:(UIImage *)image {
    if(self = [super initWithCGImage:[image CGImage]]) {
    }
    return self;
}

@end
