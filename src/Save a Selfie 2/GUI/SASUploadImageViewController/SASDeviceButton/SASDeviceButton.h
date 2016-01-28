//
//  SASDeviceButton.h
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"

typedef NS_ENUM(NSUInteger, SASDeviceButtonStatus) {
  Unselected,
  Selected
};

@interface SASDeviceButton : UIButton

// The status of the button whether its selected or not.
@property (assign, nonatomic) SASDeviceButtonStatus status;

@property (assign, nonatomic) SASDeviceType deviceType;

// Image of button when selected.
@property (nullable, strong, nonatomic) UIImage *selectedImage;

// Image of button when unselected.
@property (nullable, strong, nonatomic) UIImage *unselectedImage;

@end
