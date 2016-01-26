//
//  SASDeviceButtonView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASDeviceButtonView.h"
#import "SASDeviceButton.h"
#import "DefibrillatorButton.h"
#import "LifeRingButton.h"
#import "FirstAidKitButton.h"
#import "FireHydrantButton.h"
#import "Screen.h"
#import "UIView+NibInitializer.h"

@interface SASDeviceButtonView ()

@property (weak, nonatomic) IBOutlet UIButton *defibButton;
@property (weak, nonatomic) IBOutlet UIButton *lifeRingButton;
@property (weak, nonatomic) IBOutlet UIButton *firstAidKitButton;
@property (weak, nonatomic) IBOutlet UIButton *fireHydrantButton;


@end

@implementation SASDeviceButtonView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (!self) {
    return nil;
  }
  
  return self;
}


- (id) awakeAfterUsingCoder:(NSCoder *)aDecoder {
  if (![self.subviews count]) {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *loadedViews = [mainBundle loadNibNamed:@"SASDeviceButtonView" owner:nil options:nil];
    
    SASDeviceButton *v = [loadedViews firstObject];
    
    v.frame = self.frame;
    v.autoresizingMask = self.autoresizingMask;
    v.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
    
    for (NSLayoutConstraint *constraint in self.constraints) {
      id firstItem = constraint.firstItem;
      if (firstItem == self) {
        firstItem = v;
      }
      
      id secondItem = constraint.secondItem;
      if (secondItem == self) {
        secondItem = v;
      }
      
      [v addConstraint:[NSLayoutConstraint constraintWithItem:firstItem
                                                    attribute:constraint.firstAttribute
                                                    relatedBy:constraint.relation
                                                       toItem:secondItem
                                                    attribute:constraint.secondAttribute
                                                   multiplier:constraint.multiplier
                                                     constant:constraint.constant]];
      return v;
    }
  }
  return self;
}

@end
