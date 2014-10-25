//
//  UIButton+Maker.m
//  Photoapp4it
//
//  Created by Peter FitzGerald on 25/05/2013.
//  Copyright (c) 2013 Peter FitzGerald. All rights reserved.
//

#import "UIButton+Maker.h"

@implementation UIButton (Maker)

+(UIButton *)makeButton:(NSString *)buttonText dimensions:(CGRect)dimensions {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = dimensions;
	[button setShowsTouchWhenHighlighted:YES];
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setEnabled:YES];
    [button setUserInteractionEnabled:YES];
	button.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
	CALayer *layer = button.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 3.0f;
    layer.borderColor = [UIColor colorWithWhite:0.3f alpha:0.2f].CGColor;
	button.alpha = 1.0;
	[button setTitleColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.5 alpha:1.0] forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
	[UIButton addShineLayer:button];
	return button;
}

+(void)addShineLayer:(UIButton *)button {
	// from here: http://undefinedvalue.com/2010/02/27/shiny-iphone-buttons-without-photoshop
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = button.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [button.layer addSublayer:shineLayer];
	[button.layer setOpacity:1.0];
}

@end
