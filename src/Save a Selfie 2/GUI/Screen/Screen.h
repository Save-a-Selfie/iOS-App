//
//  Screen.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Allows for different heights to be taken into account when
 the navigation bar and tab bar a present on a view.
 */
typedef NS_OPTIONS(NSUInteger, ScreenHeightOptions) {
    /**
     ScreenHeightOptionsWithNavBar includes the status bar and the navigation
     bar.
     */
    ScreenHeightOptionsWithNavBar  = 1 << 0,
    
    ScreenHeightOptionsWithTabBar = 1 << 1
};


/**
 Please note these methods only work for iPhone and
 have not been tested for an iPad.
 */
@interface Screen : NSObject

+ (CGFloat) width;
+ (CGFloat) height;
+ (CGFloat) heightWithOptions: (ScreenHeightOptions) options;

@end
