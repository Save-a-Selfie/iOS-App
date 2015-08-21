//
//  SASGalleryContainer.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"



@interface SASGalleryContainer : NSObject


/**
 Returns an image for the associated device.
 */
- (UIImage *) imageForDevice:(SASDevice *) device;


- (NSInteger) deviceCount;

/**
 Adds an image with an associated device as a key.
 */
- (void) addImage:(UIImage *) image forDevice:(SASDevice *) device;

/**
 Clears the entire data set.
 */
- (void) clear;
@end
