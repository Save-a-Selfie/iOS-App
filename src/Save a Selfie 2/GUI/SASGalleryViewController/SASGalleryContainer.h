//
//  SASGalleryContainer.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"

typedef NS_ENUM(NSUInteger, SASGalleryFilterType) {
    /**
     No filtering wil be performed on the internal data structure.
     */
    SASGalleryFilterTypeDefault,
    
    
    /**
     Filters the array to show the closest image
     at index 0 of the array.
     The lower the image index withing the array, the closer it is to the
     current user's location and vice versa.
     */
    SASGalleryFilterTypeLocation
};



@interface SASGalleryContainer : NSObject


/**
 Default is SASGallerFilterTypeDefault
 */
@property (assign, nonatomic) SASGalleryFilterType filterType;


- (void) addImage: (UIImage *) image forDevice:(SASDevice *) device;

/**
 Returns all the images in the correct order according to the `filtertype` property. 
 */
- (NSArray*) images;

- (NSInteger) deviceCount;


@end
