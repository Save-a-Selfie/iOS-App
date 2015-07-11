//
//  SASGalleryCell.m
//  Save a Selfie
//
//  Created by Stephen Fox on 11/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryCell.h"



@implementation SASGalleryCell

@synthesize delegate;

@synthesize device;
@synthesize imageView;


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self addTapGestureRecognizer];
    }
    return self;
}


- (void) addTapGestureRecognizer {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardTapToDelegate)];
    [self addGestureRecognizer:tap];
    
}


- (void) forwardTapToDelegate {
    
    SASAnnotation *annotation = [[SASAnnotation alloc] initAnnotationWithDevice:self.device
                                                                          index:0];
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sasGalleryCellDelegate:wasTappedWithObject:)]) {
        [self.delegate sasGalleryCellDelegate:self wasTappedWithObject:annotation];

    }
}
@end
