//
//  SASGalleryViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 11/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryCollectionViewController.h"
#import "SASGalleryCell.h"
#import "SASObjectDownloader.h"
#import "SASImageViewController.h"
#import "SASUtilities.h"
#import <SDWebImageDownloader.h>
#import "SASActivityIndicator.h"
#import "SASGalleryContainer.h"




@interface SASGalleryCollectionViewController() <SASGalleryCellDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
SASObjectDownloaderDelegate>

@property (strong, nonatomic) SASObjectDownloader *sasObjectDownloader;

@property (strong, nonatomic) __block SASGalleryContainer *images;

@property (strong, nonatomic) __block SASActivityIndicator *sasActivityIndicator;



@property (assign, nonatomic) NSInteger imageToLoad;

@end



@implementation SASGalleryCollectionViewController




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imageToLoad = 0;
    
    
    if (!self.sasObjectDownloader) {
        self.sasObjectDownloader = [[SASObjectDownloader alloc] initWithDelegate:self];
    }
    
    self.navigationController.navigationBar.topItem.title = @"Gallery";
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [_sasObjectDownloader downloadObjectsFromServer];
}

- (void) reloadCollectionView {
    [self.collectionView reloadData];
}


#pragma mark SASObjectDownloader Delegate
- (void)sasObjectDownloader:(SASObjectDownloader *)downloader didDownloadObjects:(NSMutableArray *)objects {
    [self beginFetchingImagesFromObjectData:objects];
}


- (void) beginFetchingImagesFromObjectData:(NSMutableArray *) objects {
    
    if(!self.images) {
        self.images = [[SASGalleryContainer alloc] init];
    }

    
    // Loop through all the objects and initliase
    // an SASDevice from each object at index.
    // Create a URL from the devices imageURL string.
    // Then download the image.
    for (int i; i < 20; i++) {
        
        
        // Get the image for the cell.
        SASDevice *deviceAtIndex = [objects objectAtIndex:i];
        
        NSString *imageURL = deviceAtIndex.imageURL;
        
        NSURL *url = [NSURL URLWithString:imageURL];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url
                                                            options:0
                                                           progress:nil
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                              if (image && finished) {
                                                                  [self.images addImage:image];
                                                                  NSLog(@"%ld", [self.images imageCount]);
                                                              }
                                                          }];
    }
    [self reloadCollectionView];
    
    
}


#pragma mark CollectionView Data source
- (SASGalleryCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SASGalleryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [self.images images][indexPath.row];
    
    return cell;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld", [self.images imageCount]);
    return [self.images imageCount];
}






#pragma SASGalleryCellDelegate
- (void)sasGalleryCellDelegate:(SASGalleryCell *)cell wasTappedWithObject:(SASAnnotation *)object {

    SASImageViewController *sasImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SASImageViewController"];
    sasImageViewController.annotation = object;
    [self.navigationController pushViewController:sasImageViewController animated:YES];
}


- (void) calculatePriorityForCell:(SASGalleryCell*) cell withDevice:(SASDevice *) device {
    
}




@end
