//
//  SASGalleryCell.m
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryCell.h"
#import "SASMapAnnotationRetriever.h"
#import "SASActivityIndicator.h"


@interface SASGalleryCell()

@property(nonatomic, strong) SASActivityIndicator *sasActivityIndicator;


@end


@implementation SASGalleryCell

@synthesize sasDevice;
@synthesize imageView;
@synthesize sasActivityIndicator;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.sasActivityIndicator = [[SASActivityIndicator alloc] init];
        //[self addSubview:sasActivityIndicator];
        //[self.sasActivityIndicator startAnimating];
        
        [self.imageView addObserver:self
                         forKeyPath:@"image"
                            options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                            context:nil];

    }
    return self;
}


- (void) observeValueForKeyPath:(NSString *)path ofObject:(id) object change:(NSDictionary *) change context:(void *)context
{
    // this method is used for all observations, so you need to make sure
    // you are responding to the right one.
    if (object == imageView && [path isEqualToString:@"image"])
    {
        UIImage *newImage = [change objectForKey:NSKeyValueChangeNewKey];
        
        if(newImage != nil) {
            [self.sasActivityIndicator stopAnimating];
        }
    }
}


@end
