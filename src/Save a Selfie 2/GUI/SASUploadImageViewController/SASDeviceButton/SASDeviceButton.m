//
//  SASDeviceButton.m
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASDeviceButton.h"


@implementation SASDeviceButton

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
  _status = Unselected;
}

@end
