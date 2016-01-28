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
  self.selectedImage = [UIImage imageNamed:@"FirstAidKit"];
  self.unselectedImage = [UIImage imageNamed:@"FirstAidKitUnselected"];
  self.deviceType = SASDeviceTypeFirstAidKit;
}


@end
