//
//  LifeRingButton.m
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "LifeRingButton.h"

@implementation LifeRingButton


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
  self.selectedImage = [UIImage imageNamed:@"LifeRing"];
  self.unselectedImage = [UIImage imageNamed:@"LifeRingUnselected"];
}
@end
