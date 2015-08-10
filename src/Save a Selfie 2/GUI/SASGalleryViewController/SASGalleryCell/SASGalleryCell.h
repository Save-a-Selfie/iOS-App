//
//  SASGalleryCell.h
//  Save a Selfie
//
//  Created by Stephen Fox on 11/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"
#import "SASAnnotation.h"

@class SASGalleryCell;

@protocol SASGalleryCellDelegate <NSObject>

- (void) sasGalleryCellDelegate:(SASGalleryCell *) cell wasTappedWithObject:(SASDevice*) device;

@end

@interface SASGalleryCell : UICollectionViewCell

@property (nonatomic, weak) id<SASGalleryCellDelegate> delegate;

@property (strong, nonatomic) SASDevice *device;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
