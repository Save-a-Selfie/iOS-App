//
//  SASColour.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASColour.h"


@implementation SASColour

// Device types:
// 0 - Defibrillator
// 1 - Life Ring
// 2 - First Aid Kit
// 3 - Fire Hydrant



+ (UIColor *)sasRedAEDColour {
    return [UIColor colorWithRed:0.956
                           green:0.372
                            blue:0.372
                           alpha:1.0];
}


+ (UIColor *)sasOrangeLifeRingColour {
    return [UIColor colorWithRed:1.0
                           green:0.638
                            blue:0.360
                           alpha:1.0];
}


+ (UIColor *)sasGreenFirstAidColour {
    return [UIColor colorWithRed:0.055
                           green:0.545
                            blue:0.482
                           alpha:1.0];
}


+ (UIColor *)sasYellowFireHydrantColur {
    return [UIColor colorWithRed:1.0
                           green:0.95
                            blue:0.352
                           alpha:1.0];
}


+ (UIColor*) getSASColourForDeviceType:(SASDeviceType) deviceType {
    
    switch (deviceType) {
        case Defibrillator:
            return [SASColour sasRedAEDColour];
            break;
            
        case LifeRing:
            return [SASColour sasOrangeLifeRingColour];
            break;
        
        case FirstAidKit:
            return [SASColour sasGreenFirstAidColour];
            break;
            
        case FireHydrant:
            return [SASColour sasYellowFireHydrantColur];
            break;
            
        case All:
            return [[UIColor alloc] init];
            
        default:
            break;
    }
}



@end
