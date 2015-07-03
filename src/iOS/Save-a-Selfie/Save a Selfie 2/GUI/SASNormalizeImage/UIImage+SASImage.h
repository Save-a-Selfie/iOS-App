//
//  UIImage+SASNormalizeImage.h
//  Save a Selfie
//
//  Created by Stephen Fox on 10/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SASImage)

- (UIImage *)normalizedImage;

// @Disccusion:
//  Merges two image together.
+ (UIImage *) doubleMerge: (UIImage *) photo
                withImage:(UIImage *) logo1 atX: (int) x andY:(int)y withStrength:(float) mapOpacity
                 andImage:(UIImage *) logo2 atX2:(int) x2 andY2:(int)y2
                 strength: (float) strength;

@end
