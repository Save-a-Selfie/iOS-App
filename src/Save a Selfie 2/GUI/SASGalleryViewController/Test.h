//
//  Test.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SASGalleryControllerDataSource <UICollectionViewDataSource>

/**
 Called when the next set/ group of images are needed
 by the gallery. */
- (void) imagesWithinRange:(NSRange) range
                completion: (void(^)(BOOL completion)) completion;

@end
