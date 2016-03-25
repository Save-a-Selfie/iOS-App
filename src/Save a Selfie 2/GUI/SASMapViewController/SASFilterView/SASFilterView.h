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

- (void) sasFilterView:(SASFilterView*) view didFilterType:(SASDeviceType) type;

@end

@interface SASFilterView : UIView


@property (weak, nonatomic) id<SASFilterViewDelegate> delegate;



/**
 Animate SASFilterView into another view.
 */
- (void) animateIntoView:(UIView*) view;

- (void) restoreToDefault;
@end