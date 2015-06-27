//
//  SASColour.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASColour : NSObject

+ (UIColor*) sasOrangeLifeRingColour;
+ (UIColor*) sasYellowFireHydrantColur;
+ (UIColor*) sasGreenFirstAidColour;
+ (UIColor*) sasRedAEDColour;

+ (NSArray*) getSASColours;

@end
