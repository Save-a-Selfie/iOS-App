//
//  Screen.m
//  SASMapView
//
//  Created by Stephen Fox on 25/05/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "Screen.h"

@implementation Screen


+ (CGFloat)width {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)height {
    return [[UIScreen mainScreen] bounds].size.height;
}
@end
