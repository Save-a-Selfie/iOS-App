//
//  SASFilterView.m
//  
//
//  Created by Stephen Fox on 12/06/2015.
//
//

#import "SASFilterView.h"
#import "SASUtilities.h"
#import "ILTranslucentView.h"

@implementation SASFilterView

- (instancetype)init {
    if(self = [super init]) {
       self = [[[NSBundle mainBundle]
                loadNibNamed:@"SASFilterView"
                owner:self
                options:nil]
               firstObject];
        
        
        ILTranslucentView *blur = [ILTranslucentView new];
        blur.frame = self.frame;
        
        blur.backgroundColor = [UIColor clearColor];
        blur.translucentStyle = UIBarStyleDefault;
        blur.translucentTintColor = [UIColor clearColor];
        blur.translucentAlpha = 1.0;
        blur.layer.cornerRadius = 8.0;

        [self addSubview:blur];
        [self sendSubviewToBack:blur];
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}




// Animates into the views center.
- (void) animateIntoView:(UIView*) view {
    
    [UIView animateWithDuration:0.4
                          delay:0.1
         usingSpringWithDamping:0.6
          initialSpringVelocity:.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){ self.center = view.center; }
                     completion:nil];
}
@end
