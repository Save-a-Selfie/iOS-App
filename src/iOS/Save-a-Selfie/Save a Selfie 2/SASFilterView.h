//
//  SASFilterView.h
//  
//
//  Created by Stephen Fox on 12/06/2015.
//
//

#import <UIKit/UIKit.h>
#import "Device.h"

@class SASFilterView;


@protocol SASFilterViewDelegate <NSObject>

// Passes to the delegate the DeviceType correseponding to the button which was pressed.
- (void) sasFilterView:(SASFilterView*) view buttonWasPressed:(DeviceType) device;

@end

@interface SASFilterView : UIView


@property(nonatomic, weak) id<SASFilterViewDelegate> delegate;

// Animates with a custom animation into the view of the reciever.
- (void) animateIntoView:(UIView*) view;

@end
