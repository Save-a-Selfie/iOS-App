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


- (void) addImage: (UIImage *) image;

/**
 Returns all the images in the correct order according to the `filtertype` property. 
 */
- (NSArray*) images;

- (NSInteger) deviceCount;


@end
