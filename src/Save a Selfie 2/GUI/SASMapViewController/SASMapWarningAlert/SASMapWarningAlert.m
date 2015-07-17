//
//  SASMapWarningAlert.m
//  Save a Selfie
//
//  Created by Stephen Fox on 14/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASMapWarningAlert.h"
#import "UIView+NibInitializer.h"
#import "SASGreyView.h"
#import "Screen.h"

@interface SASMapWarningAlert()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) id leftButtonTarget;
@property (assign, nonatomic) SEL leftButtonAction;
@property (weak, nonatomic) id rightButtonTarget;
@property (assign, nonatomic) SEL rightButtonAction;

@property (strong, nonatomic) SASGreyView *greyView;


@end

@implementation SASMapWarningAlert

@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize titleLabel = _titleLabel;
@synthesize messageTextView = _messageTextView;
@synthesize leftButtonTitle;
@synthesize rightButtonTitle;

@synthesize leftButtonAction;
@synthesize leftButtonTarget;
@synthesize rightButtonAction;
@synthesize rightButtonTarget;



#pragma mark Object Life Cycle
- (instancetype)initWithTitle:(NSString*) title andMessage:(NSString *) message {
    if(self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"SASMapWarningAlert" owner:self options:nil][0];
        
        self.layer.cornerRadius = 4.0;
        
        _leftButton.layer.cornerRadius = 4.0;
        _rightButton.layer.cornerRadius = 4.0;
        
        _titleLabel.text = title;
        _messageTextView.text = message;
        
    }
    return self;
}



#pragma Mutators.
- (void)setLeftButtonTitle:(NSString *) title {
    [self.leftButton setTitle:title forState:UIControlStateNormal];
}

- (void)setRightButtonTitle:(NSString *) title {
    [self.rightButton setTitle:title forState:UIControlStateNormal];
}



#pragma mark Actions for buttons.
- (void)addActionForLeftButton:(SEL)action target:(id)target {
    
    self.leftButtonAction = action;
    self.leftButtonTarget = target;
    
    [self.leftButton addTarget:self action:@selector(animateOutOfView:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addActionforRightButton:(SEL)action target:(id)target {
    
    self.rightButtonAction = action;
    self.rightButtonTarget = target;
    
    [self.rightButton addTarget:self action:@selector(animateOutOfView:) forControlEvents:UIControlEventTouchUpInside];
}




#pragma Animations 
- (void) animateIntoView:(UIView *) view {
    
    if (self.greyView == nil) {
        self.greyView = [[SASGreyView alloc]initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
    }

    
    

    [view addSubview:self];
    
    self.center = view.center;
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.5
                          delay:0.1
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{self.alpha = 1.0;}
                     completion:nil];

}


- (void) animateOutOfView:(id) sender {
    
    if(sender == self.leftButton) {

        [self.leftButtonTarget performSelector:self.leftButtonAction
                               withObject:nil
                               afterDelay:0.0];
    }
    else {

        [self.rightButtonTarget performSelector:self.rightButtonAction
                                     withObject:nil
                                     afterDelay:0.0];
    }
    
    [self removeFromSuperview];
    
}

@end
