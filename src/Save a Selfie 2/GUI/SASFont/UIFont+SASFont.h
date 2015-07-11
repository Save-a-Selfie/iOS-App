//
//  UIFont+SASFont.h
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (SASFont)

+ (UIFont*) sasFontForNavBarTitle;

+ (UIFont*)sasFontWithSize:(float) size;

+ (void) increaseCharacterSpacingForLabel:(UILabel*) label byAmount:(float) amount;

@end
