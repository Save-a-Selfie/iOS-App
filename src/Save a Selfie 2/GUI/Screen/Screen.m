//
//  Screen.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
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

+ (CGFloat) heightWithOptions: (ScreenHeightOptions) options {

    printf("Value: %lu.\n", (unsigned long)options);
    
    if ((options & ScreenHeightOptionsWithTabBar) == ScreenHeightOptionsWithTabBar) {
        printf("TAB BAR\n");
        return [self height] - 49;
    }
    else if ((options & ScreenHeightOptionsWithNavBar) == ScreenHeightOptionsWithNavBar) {                printf("NAV BAR\n");
        return [self height] - 64;
    }
    else {
        printf("BOTH\n");
        return [self height] - (49 + 64);
    }
    
}
@end
