//
//  SASBarButtonItem.m
//  Save a Selfie
//
//  Created by Stephen Fox on 01/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASBarButtonItem.h"
#import "SASFont/UIFont+SASFont.h"

@implementation SASBarButtonItem


- (instancetype)initWithTitle:(NSString *)title
                        style:(UIBarButtonItemStyle)style
                       target:(id)target
                       action:(SEL)action {
    
    if(self = [super initWithTitle:title
                             style:style
                            target:target
                            action:action]) {
        
        [self setTitleTextAttributes:@{NSFontAttributeName: [UIFont sasFontWithSize:15.0f]}
                            forState:UIControlStateNormal];
        
    }
    return self;
}
@end
