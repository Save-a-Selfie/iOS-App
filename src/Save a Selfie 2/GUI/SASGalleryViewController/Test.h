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
 Downloads next set of images, within a specified range.
 @param range The range of images to download.
 @param completion Called when all images within the specified range
                   have been downloaded. Please note even when completion is NO
                   a new will have been downloaded. Only when all have been retrieved is YES passed.
 */
- (void) imagesWithinRange:(NSRange) range
                completion: (void(^)(BOOL finished)) completion;

@end
