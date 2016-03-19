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



- (void)imagesWithinRange:(NSRange)range withQuery:(SASNetworkQuery *)query completion:(void (^)(BOOL))completion {
  [self downloadImagesWithinRange:range withQuery:query completion:completion];
}



- (void) downloadImagesWithinRange:(NSRange) range
                         withQuery:(SASNetworkQuery*) query
                        completion:(void(^)(BOOL completed)) completed {
  
  // Create all the urls for this range of images
  // to be downloaded from the server.
  NSMutableArray<NSURL*> *imageURLs;
  if (query.type == SASNetworkQueryImageDownload) {
    for (NSString *stringUrl in query.imagePaths) {
      [imageURLs addObject:[NSURL URLWithString:stringUrl]];
    }
  }
  
  __block int downloadAmount = (int)range.length - (int)range.location;
  __block int count = 0;
  
  for (int i = (int)range.location; i < (int)range.length; ++i) {
    if (!(i >= totalImagesDownloaded)) {
      
      if (!self.worker) { return; }
      
      [self.worker downloadImageWithQuery:query completionResult:^(UIImage *image) {
        // Add image reference to our `datasource`.
        [self.images addObject:image];
        dispatch_async(dispatch_get_main_queue(), ^{
          ++count;
          ++totalImagesDownloaded;
          if (count == downloadAmount) {
            completed(YES);
          } else {
            completed(NO);
          }
        });
      }];

    }
  }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.images count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  self.galleryCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];

  UIImage *image = [self.images objectAtIndex:indexPath.row];
  
  self.galleryCell.delegate = self.cellDelegate;
  
  // Set the cell's image.
  self.galleryCell.imageView.image = image;
  
  return self.galleryCell;
}



@end
