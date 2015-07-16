//
//  SASNoticeView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 14/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASNoticeView : UIView

- (void) setTitle:(NSString *) title;
- (void) setNotice:(NSString *) notice;


// Animations
- (void) animateIntoView:(UIView *) view;
- (void) animateOutOfView;

@end
