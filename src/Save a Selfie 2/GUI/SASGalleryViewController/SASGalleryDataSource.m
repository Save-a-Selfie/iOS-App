//
//  SASGalleryDataSource.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASGalleryDataSource.h"
#import "SASGalleryCell.h"
#import "DefaultDownloadWorker.h"
#import <SDWebImageDownloader.h>
#import "SASGalleryContainer.h"
#import "SASImageViewController.h"

@interface SASGalleryDataSource ()

@property (strong, nonatomic) NSString *reuseIdentifier;
@property (strong, nonatomic) SASNetworkManager *networkManager;
@property (strong, nonatomic) id<DownloadWorker> worker;
@property (strong, nonatomic) NSArray<SASDevice*> *downloadedObjects;
@property (strong, nonatomic) SASGalleryContainer *galleryContainer;
@property (weak, nonatomic) SASGalleryCell *galleryCell;
@property (assign, nonatomic) BOOL objectsDowloaded;

@end



@implementation SASGalleryDataSource

#pragma mark Object life cycle.
- (instancetype)initWithReuseCell:(SASGalleryCell *)reuseCell
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
  
  return self;
  
}


- (void) downloadFromServer:(void(^)(BOOL)) completion {
  if (!self.networkManager) {
    self.networkManager = [SASNetworkManager sharedInstance];
  }
  
  SASNetworkQuery *query = [SASNetworkQuery queryWithType:SASNetworkQueryTypeAll];
  [self.networkManager downloadWithQuery:query
                               forWorker:[[DefaultDownloadWorker alloc]init]
                              completion:^(NSArray* devices) {
                                self.downloadedObjects = devices;
                                self.objectsDowloaded = YES;
                                completion(YES);
                              }];
}



- (void)imagesWithinRange:(NSRange)range completion:(void (^)(BOOL))completion {
  [self downloadImagesWithinRange:range completion:completion];
}


- (void) downloadImagesWithinRange:(NSRange) range completion:(void(^)(BOOL completed)) completed {
  
  __block int downloadAmount = (int)range.length - (int)range.location;
  __block int count = 0;
  
  for (int i = (int)range.location; i < (int)range.length; ++i) {
    if (!(i >= self.downloadedObjects.count)) {
      
      SASDevice *deviceAtIndex = [self.downloadedObjects objectAtIndex:i];
      
      NSString *imageURL = deviceAtIndex.imageURLString;
      NSURL *url =[NSURL URLWithString:imageURL];
      
      [SDWebImageDownloader.sharedDownloader
       downloadImageWithURL:url
       options:0
       progress:nil
       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
         
         if (image && finished) {
           [self.galleryContainer addImage:image forDevice:deviceAtIndex];
           
           dispatch_async(dispatch_get_main_queue(), ^() {
             count++;
             if (count == downloadAmount) {
               completed(YES);
             } else {
               completed(NO);
             }
           });
         }
       }];
    }
  }
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.galleryContainer deviceCount];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  self.galleryCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
  
  SASDevice *device = self.downloadedObjects[indexPath.row];
  UIImage *image = [self.galleryContainer imageForDevice:device];
  
  // Set the cell's image.
  self.galleryCell.imageView.image = image;
  
  // Set the cell's device.
  self.galleryCell.device = device;
  return self.galleryCell;
}



@end
