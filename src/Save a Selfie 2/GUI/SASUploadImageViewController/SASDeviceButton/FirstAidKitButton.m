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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (self.status == Unselected) {
    self.status = Selected;
    [self setImage:[UIImage imageNamed:@"FirstAidKit"] forState:UIControlStateNormal];
  } else {
    self.status = Unselected;
    [self setImage:[UIImage imageNamed:@"FirstAidKitUnselected"] forState:UIControlStateNormal];
  }
}

@end
