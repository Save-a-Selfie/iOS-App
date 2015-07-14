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

@property (strong, nonatomic) SASGreyView *greyView;


@end

@implementation SASMapWarningAlert

@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize titleLabel = _titleLabel;
@synthesize messageTextView = _messageTextView;
@synthesize leftButtonTitle;
@synthesize rightButtonTitle;
@synthesize greyView;



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
    [self.leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addActionforRightButton:(SEL)action target:(id)target {
    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}



#pragma Animations 
- (void) animateIntoView:(UIView *) view {
    
    self.greyView = [[SASGreyView alloc]initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
    
    
    [view addSubview:greyView];
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


- (void) animateOutOfView {
    [self.greyView removeFromSuperview];
    [self removeFromSuperview];
}

@end
