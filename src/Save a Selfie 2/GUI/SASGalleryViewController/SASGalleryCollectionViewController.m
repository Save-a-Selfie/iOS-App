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



@interface SASGalleryCollectionViewController() <SASGalleryCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SASObjectDownloaderDelegate>

@property (strong, nonatomic) SASObjectDownloader *sasObjectDownloader;
@property (weak, nonatomic) NSMutableArray *objectsForCells;
@property (strong, nonatomic) NSMutableArray* imagesForCell;

@property (assign, nonatomic) __block BOOL readyToSetImageToCells;


@end



@implementation SASGalleryCollectionViewController

@synthesize sasObjectDownloader;
@synthesize objectsForCells;
@synthesize imagesForCell;
@synthesize readyToSetImageToCells;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.readyToSetImageToCells = NO;
    
    if (self.sasObjectDownloader == nil) {
        self.sasObjectDownloader = [[SASObjectDownloader alloc] initWithDelegate:self];
    }
    
    self.navigationController.navigationBar.topItem.title = @"Gallery";
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.sasObjectDownloader downloadObjectsFromServer];
}


#pragma mark SASObjectDownloader Delegate
- (void)sasObjectDownloader:(SASObjectDownloader *)downloader didDownloadObjects:(NSMutableArray *)objects {
    self.objectsForCells = objects;
    
    [self beginFetchingImagesFromObjectData:objectsForCells];
}


- (void) beginFetchingImagesFromObjectData:(__weak NSMutableArray*) objects {
    
    __block int imageCount = 0;
    printf("Object count: %lu", (unsigned long)objects.count);
    
    if (self.imagesForCell == nil) {
        self.imagesForCell = [[NSMutableArray alloc] init];
    }
    
    // Loop through all the objects and initliase
    // an SASDevice from each object at index.
    // Create a URL from the devices imageURL string.
    // Then download the image.
    for (int i = 0; i < objects.count; i++) {
        
        
        
        SASDevice *device = objects[i];
        
        NSURL *url = [NSURL URLWithString:device.imageURL];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url
                                                            options:0
                                                           progress:nil
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished){
                                                              
                                                              if(image && finished) {
                                                                  [self.imagesForCell addObject:image];
                                                                  imageCount++;
                                                                  printf("%d\n", imageCount);
                                                              }
                                                              
                                                              if (imageCount == objects.count) {
                                                                  self.readyToSetImageToCells = YES;
                                                                  [self.collectionView reloadData];
                                                              }
                                                          }];

    }
}


#pragma mark CollectionView Data source
- (SASGalleryCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SASGalleryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (self.readyToSetImageToCells) {
        cell.imageView.image = self.imagesForCell[indexPath.row];
        cell.device = (SASDevice *)self.objectsForCells;
    }
    return cell;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.readyToSetImageToCells) {
        return self.imagesForCell.count;
    } else {
        return 0;
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
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
