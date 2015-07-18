//
//  SASColour.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"

@interface SASColour : NSObject

+ (UIColor*) sasOrangeLifeRingColour;
+ (UIColor*) sasYellowFireHydrantColur;
+ (UIColor*) sasGreenFirstAidColour;
+ (UIColor*) sasRedAEDColour;

// @return the colour assocatied with the device.
+ (UIColor*) getSASColourForDeviceType:(SASDeviceType) deviceType;

@end
