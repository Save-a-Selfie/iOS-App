//
//  Test.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASNetworkQuery.h"

@protocol SASGalleryControllerDataSource <UICollectionViewDataSource>

/**
 Downloads next set of images.
 @query query The query used when dowloading.
 @param completion A completion callback to the client when
                   a new image has been downlooaded within
                   the specified range.
                   YES - Will be passed if the full range of
                   images have been downloaded.
                   NO - The full range of images have not been
                   downloaded, however a new image has been downloaded.
 */
- (void) imagesWithQuery:(SASNetworkQuery*) query
                completion: (void(^)(BOOL finished)) completion;

@end
