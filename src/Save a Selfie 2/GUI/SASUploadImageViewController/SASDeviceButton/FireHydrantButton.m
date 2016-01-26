//
//  FireHydrantButton.m
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "FireHydrantButton.h"

@implementation FireHydrantButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  if (!self)
    return nil;
  [self setImage:[SASDevice getUnselectedDeviceImageForDevice:SASDeviceTypeFireHydrant]
        forState:UIControlStateNormal];
  return self;
}

@end