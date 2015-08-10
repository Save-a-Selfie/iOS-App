//
//  SASGalleryContainer.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASGalleryContainer : NSObject


@property (weak, nonatomic) NSArray *images;

- (void) addImage: (UIImage *) image;

- (NSInteger) imageCount;

@end
