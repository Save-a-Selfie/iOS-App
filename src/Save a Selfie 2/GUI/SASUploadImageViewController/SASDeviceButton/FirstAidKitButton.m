//
//  FirstAidKitButton.m
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "FirstAidKitButton.h"


@implementation FirstAidKitButton

- (instancetype)init {
  self = [super init];
  if (!self)
    return nil;
  [self setImage:[SASDevice getUnselectedDeviceImageForDevice:SASDeviceTypeFirstAidKit]
        forState:UIControlStateNormal];
  return self;
}


@end
