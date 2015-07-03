//
//  SASGalleryCell.m
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryCell.h"

@interface SASGalleryCell()


@property(nonatomic, strong) UIImageView* imageView;

@end


@implementation SASGalleryCell

@synthesize sasAnnotation;
@synthesize imageView;


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}


- (void)setSasAnnotation:(SASAnnotation *)sasAnnotation {
}

@end
