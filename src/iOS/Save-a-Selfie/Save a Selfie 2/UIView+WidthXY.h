//
//  UIView+WidthXY.h
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 25/10/2014.
//  Copyright (c) 2014 Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WidthXY)
-(void)moveObject:(float)y overTimePeriod:(float)period;
-(void)changeViewWidth:(float)newWidth atX:(float)x centreIt:(BOOL)centrify duration:(float)duration;
@end