//
//  SASAlertView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 02/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *alertTitle;
@property (weak, nonatomic) IBOutlet UITextView *alertMessage;
@property (weak, nonatomic) IBOutlet UIButton *alertButton;

- initWithTitle:(NSString*) title message:(NSString*) message andButtonTitle:(NSString*) buttonTitle Withtarget:(id) target action:(SEL) action;


- (void) animateIntoView:(UIView*) view;
- (void) animateOutOfView:(UIView*) view;

@end
