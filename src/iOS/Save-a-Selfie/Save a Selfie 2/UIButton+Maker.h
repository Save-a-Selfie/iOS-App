//
//  UIButton+Maker.h
//  Photoapp4it
//
//  Created by Peter FitzGerald on 25/05/2013.
//  Copyright (c) 2013 Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIButton (Maker)

+(UIButton *) makeButton:(NSString *)buttonText dimensions:(CGRect)dimensions;
+(void)addShineLayer:(UIButton *)button;

@end
