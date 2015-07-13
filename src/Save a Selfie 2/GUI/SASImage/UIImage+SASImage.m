//
//  UIImage+SASNormalizeImage.m
//  Save a Selfie
//
//  Created by Stephen Fox on 10/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "UIImage+SASImage.h"
#import "UIImage+Resize.h"


@implementation UIImage (SASImage)


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


// @Disccusion:
//  Merges two image together.
+ (UIImage *) doubleMerge: (UIImage *) photo
                withImage:(UIImage *) logo1 atX: (int) x andY:(int)y withStrength:(float) mapOpacity
                 andImage:(UIImage *) logo2 atX2:(int) x2 andY2:(int)y2
                 strength: (float) strength {
    float extraHeight = 0.0;
    // see http://stackoverflow.com/questions/10931155/uigraphicsbeginimagecontextwithoptions-and-multithreading re calling UIGraphicsBeginImageContextWithOptions on background thread – apparently it's fine
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([photo size].width,[photo size].height + extraHeight), NO, 1.0); // last parameter is scaling - should be 1.0 not 0.0, or doubles image size
    [photo drawAtPoint: CGPointMake(0,0)];
    
    [logo1 drawAtPoint: CGPointMake(x, y)
             blendMode: kCGBlendModeNormal
                 alpha: strength]; // 0 - 1
    [logo2 drawAtPoint: CGPointMake(x2, y2)
             blendMode: kCGBlendModeNormal
                 alpha: strength]; // 0 - 1
    UIImage *mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergedImage;
}





@end
