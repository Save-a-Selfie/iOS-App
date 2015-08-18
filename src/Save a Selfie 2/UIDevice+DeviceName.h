//
//  UIDevice+DeviceName.h
//  Save a Selfie
//
//  Created by Stephen Fox on 18/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIDeviceModel) {
    UIDeviceModelIphone4,
    UIDeviceModelIphone4S,
    UIDeviceModelIphone5,
    UIDeviceModelIphone5C,
    UIDeviceModelIphone5S,
    UIDeviceModelIphone6,
    UIDeviceModelIphone6Plus,
    UIDeviceModelSimulator,
    UIDeviceModelIphoneUndefined // Non supported device type.
};


@interface UIDevice (DeviceName)

+ (UIDeviceModel) model;

@end
