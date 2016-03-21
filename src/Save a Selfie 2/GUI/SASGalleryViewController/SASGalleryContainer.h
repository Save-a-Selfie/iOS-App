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
 Returns an device for the associated image.
 */
- (SASDevice *) deviceForImage:(UIImage *) image;


- (NSInteger) deviceCount;


- (NSArray<UIImage*>*) keys;

/**
 Adds an image with a device as a key.
 */
- (void) addDevice:(SASDevice *) device forImage:(UIImage *) image;


/**
 Clears the entire data set.
 */
- (void) clear;
@end
