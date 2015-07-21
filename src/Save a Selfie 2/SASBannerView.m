//
//  SASBannerView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 20/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASBannerView.h"


@interface SASBannerView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation SASBannerView

@synthesize titleLabel = _titleLabel;

- (instancetype)initWithTitle:(NSString *)title {
    if(self = [super init]) {
        _titleLabel.text = title;
    }
    return self;
}


- (void) setup {
    _titleLabel
}

@end
