//
//  SASGreyView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 05/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASGreyView : UIView

// Animates into receiving view with a fade.
- (void) animateIntoView:(UIView*) view;

// Animates out of the parentView with a fade.
- (void) animateOutOfParentView;

@end
