//
//  SASFilterView.h
//  
//
//  Created by Stephen Fox on 12/06/2015.
//
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"

@class SASFilterView;


@protocol SASFilterViewDelegate <NSObject>

@optional
// Tells the delegate whether or not SASFilterView is visible is the current view hiercarchy.
// This calls the delegate o both -animateIntoView: & -animateOutOfView.
- (void) sasFilterView:(SASFilterView*)view isVisibleInViewHierarhy:(BOOL) visibility;

// Passes to the delegate the all the devices which have been selected on filterview as an NSArray.
- (void) sasFilterView:(SASFilterView*) view doneButtonWasPressedWithDevicesSelected:(NSMutableArray*) devices;

@end

@interface SASFilterView : UIView


@property(nonatomic, weak) id<SASFilterViewDelegate> delegate;

// Animates with a custom animation into the view of the reciever.
- (void) animateIntoView:(UIView*) view;

// Animates with a custom animation out of the view of the reciever.
- (void) animateOutOfView:(UIView*) view;

@end
