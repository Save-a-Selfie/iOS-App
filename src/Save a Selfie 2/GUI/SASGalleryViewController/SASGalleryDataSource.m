//
//  SASGalleryDataSource.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASGalleryDataSource.h"
#import "SASGalleryCell.h"
#import "DefaultImageDownloader.h"
#import "SASGalleryContainer.h"
#import "SASImageViewController.h"
#import "SASAppCache.h"
#import "SASNetworkManager.h"

@interface SASGalleryDataSource () {
  // The total amount of images downloaded.
  int totalImagesDownloaded;
}

@property (strong, nonatomic) NSString *reuseIdentifier;
@property (strong, nonatomic) SASNetworkManager *networkManager;
@property (strong, nonatomic) id<DownloadWorker> worker;
@property (strong, nonatomic) NSArray<NSURL*> *downloadURLs;
@property (weak, nonatomic) SASGalleryCell *galleryCell;
@property (assign, nonatomic) BOOL objectsDowloaded;
@property (weak, nonatomic) id<SASGalleryCellDelegate> cellDelegate;
@property (strong, nonatomic) NSMutableArray<UIImage*> *images;

@end



@implementation SASGalleryDataSource

#pragma mark Object life cycle.
- (instancetype)initWithReuseCell:(SASGalleryCell *) reuseCell
                  reuseIdentifier:(NSString *) identifier
                   networkManager:(SASNetworkManager *) networkManager
                           worker:(id<DownloadWorker>) worker {
  self = [super init];
  if (!self)
    return nil;
  
  _reuseIdentifier = identifier;
  _networkManager = networkManager;
  _worker = worker;
  _galleryCell = reuseCell;
  _cellDelegate = _galleryCell.delegate;
  _images = [[NSMutableArray alloc] init];
  return self;
  
}



- (void)imagesWithQuery:(SASNetworkQuery *)query completion:(void (^)(BOOL))completion {
  [self downloadImagesWithQuery:query completion:completion];
}



- (void) downloadImagesWithQuery:(SASNetworkQuery*) query
                        completion:(void(^)(BOOL completed)) completed {
  [self.worker downloadImageWithQuery:query completionResult:^(NSData *imageData) {
    dispatch_async(dispatch_get_main_queue(), ^{
      NSData* jpegData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0.5);
      UIImage *image = [UIImage imageWithData:jpegData];
      // Add image reference to our `datasource`.
      [self.images addObject:image];
      
      totalImagesDownloaded++;
      // The total image count should be the same amount
      // as imagePaths.count as these are all the files
      // we have to download. this signifies we're finished
      // downloaded this batch of images.
      if (totalImagesDownloaded == query.imagePaths.count) {
        completed(YES);
      } else {
        completed(NO);
      }
    });
  }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.images count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  self.galleryCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
  self.galleryCell.delegate = self.cellDelegate;
  // Set the cell's image.
  self.galleryCell.imageView.image = [self.images objectAtIndex:indexPath.row];
  
  return self.galleryCell;
}



@end
