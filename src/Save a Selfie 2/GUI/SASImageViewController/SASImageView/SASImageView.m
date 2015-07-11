//
//  SASImageView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 06/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASImageView.h"
#import "SASImageInspectorView.h"


// @Discussion:
// Currently for this class we will not support a tapping
// gesture to enlarge the photo with a SASImageInspectorView.
// Version 1.1.
@implementation SASImageView


- (instancetype)initWithCoder:(NSCoder *)coder {

    if (self = [super initWithCoder:coder]) {
        
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}



@end
