//
//  SASSocial.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASSocial : NSObject

/**
 Presents a UIActivityController with options to share to social media.
 
 @param textToShare  Any text you would like to share to social media.
 @param image:       The image you would like to share.
 @param target       A UIViewController which is responsible for presnting the 
                     UIActivityController.
 */
+ (void) shareToSocialMedia:(NSString*)textToShare andImage:(UIImage*)image target:(UIViewController*) target;

@end
