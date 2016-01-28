//
//  SASDeviceButtonView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"

@class SASDeviceButtonView;
@class SASDeviceButton;




@protocol SASDeviceButtonViewDelegate <NSObject>

/**
 Messages the delegate when a button has been selected.
 */
- (void) sasDeviceButtonView:(SASDeviceButtonView *) view
              buttonSelected:(SASDeviceButton*) button;

@end

@interface SASDeviceButtonView : UIView

@property (weak, nonatomic) id<SASDeviceButtonViewDelegate> delegate;


@end
