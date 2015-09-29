//
//  SASFilterViewButton.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/09/2015.
//  Copyright © 2015 Stephen Fox. All rights reserved.
//

#import "SASFilterViewButton.h"



@implementation SASFilterViewButton

- (instancetype) initWithType:(SASFilterButtonType) type {
    self = [super init];
    
    if(!self)
        return nil;
    
    [self setupButton:type];
    return self;
}


// Sets up the button image and its deviceType.
- (void) setupButton: (SASFilterButtonType) type {
    
#warning Must configure and check NSUserDefaults first.
    
    switch (type) {
        case SASFilterButtonTypeDefibrillator:
            [self setImage:[SASDevice getDeviceImageForDeviceType:SASDeviceTypeDefibrillator]
                  forState:UIControlStateNormal];
            _deviceType = SASDeviceTypeDefibrillator;
            break;
            
        case SASFilterButtonTypeLifeRing:
            [self setImage:[SASDevice getDeviceImageForDeviceType:SASDeviceTypeLifeRing]
                  forState:UIControlStateNormal];
            _deviceType = SASDeviceTypeLifeRing;
            break;
            
        case SASFilterButtonTypeFirstAidKit:
            [self setImage:[SASDevice getDeviceImageForDeviceType:SASDeviceTypeFirstAidKit]
                  forState:UIControlStateNormal];
            _deviceType = SASDeviceTypeFirstAidKit;
            break;
            
        case SASFilterButtonTypeFireHydrant:
            [self setImage:[SASDevice getDeviceImageForDeviceType:SASDeviceTypeFireHydrant]
                  forState:UIControlStateNormal];
            _deviceType = SASDeviceTypeFireHydrant;
            break;
            
        default:
            break;
    }
}
@end
