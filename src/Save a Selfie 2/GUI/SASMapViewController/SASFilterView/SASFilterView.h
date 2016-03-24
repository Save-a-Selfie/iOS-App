//
//  SASFilterView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 21/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"



@interface SASFilterView : UIView


typedef void(^SASFilterViewResponseBlock)(SASDeviceType type);

/**
 A callback block when a new device has been selected.
 */
- (void) setResponseBlock:(SASFilterViewResponseBlock) block;

/**
 Animate SASFilterView into another view.
 */
- (void) animateIntoView:(UIView*) view;


@end