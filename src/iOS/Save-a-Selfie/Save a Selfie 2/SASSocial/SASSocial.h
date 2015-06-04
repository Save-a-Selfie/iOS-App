//
//  SASSocial.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASSocial : NSObject


// Presents an UIActivityController with options to share to social media from the calling UIViewController
//
// @param textToShare: Text to post.
// @param image: Image to share.
// @param target: The UIViewController from where the UIActivityController will be called.
+ (void) shareToSocialMedia:(NSString*)textToShare andImage:(UIImage*)image target:(UIViewController*) target;

@end
