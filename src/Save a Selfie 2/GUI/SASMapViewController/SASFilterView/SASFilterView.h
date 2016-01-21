//
//  SASFilterView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 21/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"

@class SASFilterView;


@protocol SASFilterViewDelegate <NSObject>

@optional
// Tells the delegate whether or not SASFilterView is visible is the current view hiercarchy.
// This calls the delegate o both -animateIntoView: & -animateOutOfView.
- (void) sasFilterView:(SASFilterView*)view isVisibleInViewHierarhy:(BOOL) visibility;

// Passes to the delegate the type of device that has been selected on SASFilterView.
- (void) sasFilterView:(SASFilterView*) view doneButtonWasPressedWithSelectedDeviceType:(SASDeviceType) device;

@end

@interface SASFilterView : UIView


@property(nonatomic, weak) id<SASFilterViewDelegate> delegate;

// Animates with a custom animation into view.
- (void) animateIntoView:(UIView*) view;

// Animates with a custom animation out of view.
- (void) animateOutOfView;

@end