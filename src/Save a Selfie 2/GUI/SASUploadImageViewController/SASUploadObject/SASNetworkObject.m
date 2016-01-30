//
//  SASUploadImage.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASNetworkObject.h"
#import "UIImage+SASImage.h"


@interface SASNetworkObject()


@property (assign, nonatomic) BOOL deviceHasBeenSet;

@end

@implementation SASNetworkObject


- (instancetype)initWithImage:(UIImage *)imageToUpload {
    
    if (self = [super init]) {
        // @Discussion:
        // See UIImage+SASNormalizeImage.h
        // for reason on why we need to normalize
        // the image property.
        _image = [imageToUpload correctOrientation];
        
        _associatedDevice = [[SASDevice alloc] init];
        
        // This will be set to All as we need to check
        // if its been set. If .type is not All
        // then we know it has been set.
        _associatedDevice.type = SASDeviceTypeAll;
    }
    return self;
}


@end
