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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (self.status == Unselected) {
    self.status = Selected;
    [self setImage:[UIImage imageNamed:@"LifeRing"] forState:UIControlStateNormal];
  } else {
    self.status = Unselected;
    [self setImage:[UIImage imageNamed:@"LifeRingUnselected"] forState:UIControlStateNormal];
  }
}

@end
