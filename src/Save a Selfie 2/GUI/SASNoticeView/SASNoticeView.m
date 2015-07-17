//
//  SASNoticeView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 14/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASNoticeView.h"
#import "UIView+NibInitializer.h"
#import "SASGreyView.h"
#import "Screen.h"

@interface SASNoticeView()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) SASGreyView *greyView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end



@implementation SASNoticeView

@synthesize greyView;
@synthesize textView = _textView;
@synthesize titleLabel;

#pragma Object Life Cycle
- (instancetype)init {
    if(self = [super init]) {
        self = [self initWithNibNamed:@"SASNoticeView"];
        
        self.layer.cornerRadius = 4.0;
        _textView.layer.cornerRadius = 4.0;
    }
    return self;
}



- (void) setNotice:(NSString *) notice {
    self.textView.text = notice;
    [self.textView sizeToFit];
    [self sizeToFit];
    
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}



#pragma mark Animations
- (void) animateIntoView:(UIView *) view {
    
    self.greyView = [[SASGreyView alloc]initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
    
    
    [view addSubview:greyView];
    [view addSubview:self];
    [view  bringSubviewToFront:self];

    
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
    [self removeFromSuperview];
    [self.greyView removeFromSuperview];
    self.greyView = nil;
}





@end
