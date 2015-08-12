//
//  SASSponsorCardView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 12/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASSponsorCardView.h"
#import "UIView+NibInitializer.h"


@interface SASSponsorCardView()


@end

@implementation SASSponsorCardView

- (instancetype) init {
    if(self = [super init]) {
        self = [self initWithNibNamed:@"SASSponsorCardView"];
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
        self.layer.shadowOffset = CGSizeMake(-2, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
    }
    return self;
}


@end
