//
//  SASMapWarningAlert.h
//  Save a Selfie
//
//  Created by Stephen Fox on 14/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SASMapWarningAlert : UIView

@property (weak, nonatomic) NSString *leftButtonTitle;
@property (weak, nonatomic) NSString *rightButtonTitle;


- (void) addActionForLeftButton:(SEL) action target:(id) target;
- (void) addActionforRightButton:(SEL) action target:(id) target;


- (instancetype)initWithTitle:(NSString*) title andMessage:(NSString *) message;


- (void) animateIntoView:(UIView *) view;
- (void) animateOutOfView;
@end
