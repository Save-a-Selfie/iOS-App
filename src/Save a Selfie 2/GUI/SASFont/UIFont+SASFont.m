//
//  UIFont+SASFont.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "UIFont+SASFont.h"

@implementation UIFont (SASFont)

+ (UIFont *)sasFontForNavBarTitle {
    return [UIFont fontWithName:@"AvenirNext-Bold" size:0.0f];
}


+ (UIFont *) sasFontWithSize:(float) size {
    return [UIFont fontWithName:@"Avenir Next" size:size];
}


+ (void) increaseCharacterSpacingForLabel:(UILabel*) label byAmount:(float) amount {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attributedString addAttribute:NSKernAttributeName
                             value:@(amount)
                             range:NSMakeRange(0, label.text.length)];
    
    label.attributedText = attributedString;
}


@end
