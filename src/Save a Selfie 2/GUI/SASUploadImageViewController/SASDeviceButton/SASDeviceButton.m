//
//  SASDeviceButton.m
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASDeviceButton.h"


@implementation SASDeviceButton
#pragma mark Object life cycle.
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
  _status = Unselected;
}

# pragma mark touch methods.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  if (self.status == Unselected) {
    self.status = Selected;
  } else {
    self.status = Unselected;
  }
}


#pragma mark Mutators.
- (void)setSelectedImage:(UIImage *)aSelectedImage {
  _selectedImage = aSelectedImage;
  [self setImage:aSelectedImage forState:UIControlStateNormal];
}


- (void)setUnselectedImage:(UIImage *)aUnselectedImage {
  _unselectedImage = aUnselectedImage;
  [self setImage:aUnselectedImage forState:UIControlStateNormal];
}


- (void)setStatus:(SASDeviceButtonStatus)status {
  switch (status) {
    case Selected:
      _status = Selected;
      [self setImage:self.selectedImage forState:UIControlStateNormal];
      break;
      
    case Unselected:
      _status = Unselected;
      [self setImage:self.unselectedImage forState:UIControlStateNormal];
    default:
      break;
  }
}

@end
