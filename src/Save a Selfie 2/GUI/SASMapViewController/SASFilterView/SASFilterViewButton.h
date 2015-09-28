//
//  SASFilterViewButton.h
//  Save a Selfie
//
//  Created by Stephen Fox on 28/09/2015.
//  Copyright © 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SASFilterButtonType) {
    SASFilterButtonTypeDefibrillator,
    SASFilterButtonTypeLifeRing,
    SASFilterButtonTypeFirstAidKit,
    SASFilterButtonTypeFireHydrant
};



@interface SASFilterViewButton : UIButton


/**
 Initialises a new button for a specified SASFilterButtonType.
 The new instance will have its default image set according
 to whether the 'selected' property is set to YES or NO.
 The type of the button also dictates the action that will be 
 triggered when it is pressed.
 */
- (instancetype) initWithType:(SASFilterButtonType) type;

@end
