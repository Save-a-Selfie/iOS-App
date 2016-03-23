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
@property (strong, nonatomic) NSArray<NSURL*> *downloadURLs;
@property (weak, nonatomic) SASGalleryCell *galleryCell;
@property (assign, nonatomic) BOOL objectsDowloaded;
@property (weak, nonatomic) id<SASGalleryCellDelegate> cellDelegate;
@property (strong, nonatomic) NSMutableArray<UIImage*> *images;
@property (strong, nonatomic) SASGalleryContainer *container;

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
  //_worker = worker;
  _galleryCell = reuseCell;
  _cellDelegate = _galleryCell.delegate;
  _images = [[NSMutableArray alloc] init];
  _container = [[SASGalleryContainer alloc] init];
  return self;
  
}




- (void)imagesWithQuery:(SASNetworkQuery *)query completion:(void (^)(BOOL, SASDevice*)) completion {
  [self downloadImagesWithQuery:query completion:completion];
}



- (void) downloadImagesWithQuery:(SASNetworkQuery*) query
                      completion:(void(^)(BOOL completed, SASDevice *sasDevice)) completed {
  DefaultImageDownloader *worker = [[DefaultImageDownloader alloc] init];
  [worker downloadImageWithQuery:query completionResult:^(NSData *imageData, SASDevice *device) {
    __block unsigned long totalBytes = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
      totalBytes += imageData.length;
      NSLog(@"%d) Bytes: %lu", totalImagesDownloaded, imageData.length);
      UIImage *image = [UIImage imageWithData:imageData];

      // Add image reference to our `datasource`.
      if (image) {
        [self.images addObject:image];
        [self.container addDevice:device forImage:image];
      }
      totalImagesDownloaded = (int)[self.images count];
      // The total image count should be the same amount
      // as imagePaths.count as these are all the files
      // we have to download. this signifies we're finished
      // downloaded this batch of images.
      if (totalImagesDownloaded == query.devices.count) {
        NSLog(@"[DONE] Bytes: %lu", totalBytes);
        completed(YES, device);
      } else {
        completed(NO, device);
      }
    });
  }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.images count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  SASGalleryCell *galleryCell = (SASGalleryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
  
  
  UIImage *image = [self.images objectAtIndex:indexPath.row];
  galleryCell.delegate = self.cellDelegate;
  
  // Set the cell's image.
  galleryCell.imageView.image = image;
  
  // Set the cell's device.
  galleryCell.device = [self.container deviceForImage:image];
  
  return galleryCell;
}


@end
