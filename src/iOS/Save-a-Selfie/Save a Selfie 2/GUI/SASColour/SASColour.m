//
//  SASColour.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Peter FitzGerald. All rights reserved.
//

#import "SASColour.h"

@implementation SASColour

// Device types:
// 0 - Defibrillator
// 1 - Life Ring
// 2 - First Aid Kit
// 3 - Fire Hydrant


// Red Defibrillator Colour.
+ (UIColor *)sasRedAEDColour {
    return [UIColor colorWithRed:0.956
                           green:0.372
                            blue:0.372
                           alpha:1.0];
}

// Red Life Ring Colour
+ (UIColor *)sasRedLifeRingColour {
    return [UIColor colorWithRed:1.0
                           green:0.588
                            blue:0.588
                           alpha:1.0];
}

// Green First Aid Kit Colour
+ (UIColor *)sasGreenFirstAidColour {
    return [UIColor colorWithRed:0.368
                           green:0.756
                            blue:0.701
                           alpha:1.0];
}


// Blue Fire Hydrant Colour
+ (UIColor *)sasBlueFireHydrantColur {
    return [UIColor colorWithRed:0.290
                           green:0.564
                            blue:0.886
                           alpha:1.0];
}




+ (NSArray*) getSASColours {
    NSArray *colours= @[[SASColour sasRedAEDColour],
                        [SASColour sasRedLifeRingColour],
                        [SASColour sasGreenFirstAidColour],
                        [SASColour sasBlueFireHydrantColur]
                        ];
    return colours;
}

@end
