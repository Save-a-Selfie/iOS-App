//
//  SASImageView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 06/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A custom imageView which allows the user
 to tap on the image to go into a 'preview mode'.
 */
@interface SASImageView : UIImageView

/**
 Use this flag to determine whether the user
 can tap to show a larger preview of the image.
 
 Default is NO.
 */
@property (nonatomic, assign) BOOL canShowFullSizePreview;

@end
