//
//  UIImage+SASNormalizeImage.h
//  Save a Selfie
//
//  Created by Stephen Fox on 10/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SASImage)

/** 
 Images taken from the camera seem to show up in landscape.
 This method adjusts the image so it's in the correct orientation
 from which the image was taken.
 */
- (UIImage *) correctOrientation;



/** 
 Merges two image together.
 */
+ (UIImage *) doubleMerge: (UIImage *) photo
                withImage:(UIImage *) logo1 atX: (int) x andY:(int)y withStrength:(float) mapOpacity
                 andImage:(UIImage *) logo2 atX2:(int) x2 andY2:(int)y2
                 strength: (float) strength;



/**
 Creates two images that is used by this app when uploading. The two images
 are a standard image and a thumbnail (only difference is size).
 The thumbnail image is needed by the server, so
 must be uploaded along with the standard image.
 
 @param image :     The image to create the standard and thumbnail image.
 @return NSArray:   Returns the standard image and thubmnail image
                    The standard image will be the first object in the array
                    and the thumbnail will be the second image in the array.
 */
+ (NSArray *) createLargeImageAndThumbnailFromSource:(UIImage *) image;
@end
