//
//  SASGalleryCollectionViewControllerTest.m
//  Save a Selfie
//
//  Created by Stephen Fox on 10/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryCollectionViewControllerTest.h"
#import "SASObjectDownloader.h"
#import "SASGalleryContainer.h"
#import "SASDevice.h"
#import <SDWebImageDownloader.h>
#import "SASGalleryCell.h"

@interface SASGalleryCollectionViewControllerTest () <SASObjectDownloaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) SASObjectDownloader *sasObjectDownloader;
@property (strong, nonatomic) __block SASGalleryContainer *images;

@end


@implementation SASGalleryCollectionViewControllerTest

static NSString * const reuseIdentifier = @"cell";


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    if (!self.sasObjectDownloader) {
        self.sasObjectDownloader = [[SASObjectDownloader alloc] initWithDelegate:self];
    }
    
    [self.sasObjectDownloader downloadObjectsFromServer];
}


- (void) beginFetchingImages:(NSArray *) objects {
    
    if (!self.images) {
        self.images = [[SASGalleryContainer alloc] init];
    }
    

    for (int i = 0; i < 100; i++) {
        SASDevice *deviceAtIndex = [objects objectAtIndex:i];
        
        NSString *imageURLString = deviceAtIndex.imageURL;
        
        NSURL *url =[NSURL URLWithString:imageURLString];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && finished) {
                [self.images addImage:image];
                
                // This must be called on the main thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }];
    }
    

    
}

#pragma mark UICollectionViewLayout.
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}


#pragma mark <SASObjectDownladerDelegate>
- (void)sasObjectDownloader:(SASObjectDownloader *)downloader didDownloadObjects:(NSMutableArray *)objects {
    
    [self beginFetchingImages:objects];
}




#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images imageCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SASGalleryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = [self.images images][indexPath.row];

    return cell;
}



@end
