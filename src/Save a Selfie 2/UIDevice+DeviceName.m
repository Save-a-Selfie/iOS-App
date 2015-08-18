//
//  UIDevice+DeviceName.m
//  Save a Selfie
//
//  Created by Stephen Fox on 18/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "UIDevice+DeviceName.h"
#import "sys/utsname.h"

@implementation UIDevice (DeviceName)

+ (UIDeviceModel) model {
    
    // To find the correct model use this link:
    // http://stackoverflow.com/a/11197770/2875074
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *model = [NSString stringWithFormat:@"%s", systemInfo.machine];

    if ([model isEqual: @"iPhone3,1"] || [model isEqualToString:@"iPhone3,3"]) {
        return UIDeviceModelIphone4;
    } else if([model isEqualToString:@"iPhone4,1"]) {
        return UIDeviceModelIphone4S;
    } else if ([model isEqualToString:@"iPhone5,1"] || [model isEqualToString:@"iPhone5,2"]) {
        return UIDeviceModelIphone5;
    } else if ([model isEqualToString:@"iPhone5,3"] || [model isEqualToString:@"iPhone5,4"]) {
        return UIDeviceModelIphone5C;
    } else if ([model isEqualToString:@"iPhone6,1"] || [model isEqualToString:@"iPhone6,2"]) {
        return UIDeviceModelIphone5S;
    } else if ([model isEqualToString:@"iPhone7,1"]) {
        return UIDeviceModelIphone6Plus;
    } else if ([model isEqualToString:@"iPhone7,2"]) {
        return UIDeviceModelIphone6;
    } else if([model isEqualToString:@"x86_64"] || [model isEqualToString:@"i386"]) {
        return UIDeviceModelSimulator;
    }else {
        return UIDeviceModelIphoneUndefined;
    }
    
}
@end
