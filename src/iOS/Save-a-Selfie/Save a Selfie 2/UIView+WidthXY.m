//
//  UIView+WidthXY.m
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 25/10/2014.
//  Copyright (c) 2014 Peter FitzGerald. All rights reserved.
//

#import "UIView+WidthXY.h"

@implementation UIView (WidthXY)

-(void)moveObject:(float)y overTimePeriod:(float)period {
    // moves any view to y value over period seconds
    // !! autolayout must be OFF in Storyboard !!
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:period];
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

-(void)changeViewWidth:(float)newWidth atX:(float)x centreIt:(BOOL)centrify duration:(float)duration {
    // !! autolayout must be OFF in Storyboard !!
    // centrify overrides x
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    float leftGap = centrify ? (screenWidth - newWidth) * 0.5 : x;
    self.frame = CGRectMake(leftGap, self.frame.origin.y, newWidth, self.frame.size.height);
    [UIView commitAnimations];
}

@end
