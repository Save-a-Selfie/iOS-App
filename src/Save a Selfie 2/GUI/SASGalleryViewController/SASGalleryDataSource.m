//
//  SASGalleryDataSource.m
//  Save a Selfie
//
//  Created by Stephen Fox on 18/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryDataSource.h"
#import "SASObjectDownloader.h"
#import "SASGalleryCell.h"

@interface SASGalleryDataSource() <UICollectionViewDataSource, SASObjectDownloaderDelegate>

@property (strong, nonatomic) SASObjectDownloader *sasObjectDownloader;

@end


@implementation SASGalleryDataSource

@synthesize sasObjectDownloader = _sasObjectDownloader;

#pragma Object Life Cycle
- (instancetype)init {
    if(self = [super init]) {
        _sasObjectDownloader = [[SASObjectDownloader alloc] init];
    }
    return self;
}



#pragma mark UICollectionViewDataSource methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [SASGalleryCell new];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}



#pragma mark SASObjectDownloaderDelegate
- (void)sasObjectDownloader:(SASObjectDownloader *)downloader didDownloadObjects:(NSMutableArray *)objects {
    
//        self.dataForCells = devices;
//        
//        if(!self.imageBatchDownloaded) {
//            for (int i; i < CELL_LIMIT; i++) {
//                
//                
//                // Get the image for the cell.
//                SASDevice *deviceAtIndex = [self.dataForCells objectAtIndex:i];
//                
//                NSString *imageURL = deviceAtIndex.imageURL;
//                
//                NSURL *url = [NSURL URLWithString:imageURL];
//                
//                [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                    
//                }
//                                                                  completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
//                 {
//                     if (image && finished) {
//                         [self.cellImages addObject:image];
//                         NSLog(@"%@", self.cellImages);
//                         if (self.cellImages.count == CELL_LIMIT ) {
//                             
//                             self.readyToLoad = YES;
//                             [self.collectionView reloadData];
//                         }
//                     }
//                 }];
//            }
//            self.imageBatchDownloaded = YES;
//        }
}


@end
