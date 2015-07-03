//
//  SASAlertView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 02/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASAlertView : UIView

@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *message;
@property (weak, nonatomic) NSString* buttonTitle;


- (instancetype)initWithTarget:(id) target andAction:(SEL) action;


- (void) animateIntoView:(UIView*) view;
- (void) animateOutOfView:(UIView*) view;

@end
