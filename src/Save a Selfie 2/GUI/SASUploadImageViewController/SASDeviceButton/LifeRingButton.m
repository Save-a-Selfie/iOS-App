//
//  LifeRingButton.m
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "LifeRingButton.h"

@implementation LifeRingButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  if (!self)
    return nil;
  [self setImage:[SASDevice getUnselectedDeviceImageForDevice:SASDeviceTypeLifeRing]
        forState:UIControlStateNormal];
  return self;
}


@end
