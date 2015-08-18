//
//  SASGalleryCell.m
//  Save a Selfie
//
//  Created by Stephen Fox on 11/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryCell.h"
#import "UIDevice+DeviceName.h"


@implementation SASGalleryCell


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addTapGestureRecognizer];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    rect = CGRectMake(0, 0, 20, 20);
}


- (void) addTapGestureRecognizer {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardTapToDelegate)];
    [self addGestureRecognizer:tap];
    
}


- (void) forwardTapToDelegate {
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sasGalleryCellDelegate:wasTappedWithObject:)]) {
        [self.delegate sasGalleryCellDelegate:self wasTappedWithObject:self.device];
    }
}
@end
