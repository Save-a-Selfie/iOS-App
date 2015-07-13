//
//  SASColour.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASColour.h"


@implementation SASColour



+ (UIColor *)sasRedAEDColour {
    return [UIColor colorWithRed:0.788
                           green:0.003
                            blue:0.0
                           alpha:1.0];
}


+ (UIColor *)sasOrangeLifeRingColour {
    return [UIColor colorWithRed:1.0
                           green:0.638
                            blue:0.360
                           alpha:1.0];
}


+ (UIColor *)sasGreenFirstAidColour {
    return [UIColor colorWithRed:0.090
                           green:0.427
                            blue:0.019
                           alpha:1.0];
}


+ (UIColor *)sasYellowFireHydrantColur {
    return [UIColor colorWithRed:0.874
                           green:0.756
                            blue:0.011
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
