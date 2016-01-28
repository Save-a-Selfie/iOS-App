//
//  DefibrillatorButton.m
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "DefibrillatorButton.h"

@implementation DefibrillatorButton

- (instancetype)init {
  self = [super init];
  if (!self) {
    return nil;
  }
  [self commonInit];
  return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (!self) {
    return nil;
  }
  [self commonInit];
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (!self) {
    return nil;
  }
  [self commonInit];
  return self;
}

- (void) commonInit {
  self.adjustsImageWhenDisabled = NO;
  self.adjustsImageWhenHighlighted = NO;
  self.selectedImage = [UIImage imageNamed:@"Defibrillator"];
  self.unselectedImage = [UIImage imageNamed:@"DefibrillatorUnselected"];
  self.deviceType = SASDeviceTypeDefibrillator;
}

@end
