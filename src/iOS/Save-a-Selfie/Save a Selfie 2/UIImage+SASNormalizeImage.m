//
//  UIImage+SASNormalizeImage.m
//  Save a Selfie
//
//  Created by Stephen Fox on 10/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "UIImage+SASNormalizeImage.h"

@implementation UIImage (SASNormalizeImage)

// @Discussion:
// Images taken from the camera seem to show up in landscape.
// This method adjusts the image so it's in the correct orientation
// from which the image was taken.
// Taken From: http://stackoverflow.com/questions/8915630/ios-uiimageview-how-to-handle-uiimage-image-orientation
- (UIImage *)normalizedImage {
    
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}
@end
