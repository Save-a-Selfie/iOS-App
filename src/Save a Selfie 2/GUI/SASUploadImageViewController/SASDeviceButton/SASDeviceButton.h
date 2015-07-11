//
//  SASDeviceButton.h
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"

@interface SASDeviceButton : UIButton



// @Discusion:
//  This class allows us to quickly switch between two states of UIButton
//  and have its image change depending on the state of selection.
@property(nonatomic, strong) UIImage *selectedImage;
@property(nonatomic, strong) UIImage *unselectedImage;
@property(nonatomic, assign) SASDeviceType deviceType;


// Sets the UIButton's `image` property to `selectedImage`
- (void) select;

// Sets the UIButton's `image` property to `unselectedImage`
- (void) deselect;

@end
