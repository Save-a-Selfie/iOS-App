//
//  AppDelegate.h
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 15/10/2014.
//  Copyright (c) 2014 Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroViewController.h"
#define plog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

