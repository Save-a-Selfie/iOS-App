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




@interface SASGalleryCollectionViewController() <SASGalleryCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SASObjectDownloaderDelegate>

@property (strong, nonatomic) SASObjectDownloader *sasObjectDownloader;
@property (strong, nonatomic) __block NSMutableArray *objectsForCells;
@property (strong, nonatomic) __block NSMutableArray* imagesForCell;


@property (strong, nonatomic) __block SASActivityIndicator *sasActivityIndicator;



@property (assign, nonatomic) NSInteger imageToLoad;

@end



@implementation SASGalleryCollectionViewController


@synthesize sasObjectDownloader;
@synthesize objectsForCells;
@synthesize imagesForCell;
@synthesize imageToLoad;
@synthesize sasActivityIndicator;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.imageToLoad = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self.imagesForCell
                                             selector:@selector(reloadCollectionView)
                                                 name:@"arrayUpdated"
                                               object:nil];
    
//    if(self.sasActivityIndicator == nil) {
//        self.sasActivityIndicator = [[SASActivityIndicator alloc] initWithMessage:@"Loading..."];
//        [self.collectionView addSubview:self.sasActivityIndicator];
//        self.sasActivityIndicator.center = self.collectionView.center;
//        self.sasActivityIndicator.backgroundColor = [UIColor whiteColor];
//        [self.sasActivityIndicator startAnimating];
//
//    }
    
    if (self.sasObjectDownloader == nil) {
        self.sasObjectDownloader = [[SASObjectDownloader alloc] initWithDelegate:self];
    }
    
    self.navigationController.navigationBar.topItem.title = @"Gallery";
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.sasObjectDownloader downloadObjectsFromServer];
}

- (void) reloadCollectionView {
    
    [self.collectionView reloadData];
    self.imageToLoad++;
    printf("Called");
}

#pragma mark SASObjectDownloader Delegate
- (void)sasObjectDownloader:(SASObjectDownloader *)downloader didDownloadObjects:(NSMutableArray *)objects {
    self.objectsForCells = objects;
    
    [self beginFetchingImagesFromObjectData:objectsForCells];
}


- (void) beginFetchingImagesFromObjectData:(NSMutableArray *) objects {
    
    
    if (self.imagesForCell == nil) {
        self.imagesForCell = [[NSMutableArray alloc] init];
    }
    

    
    // Loop through all the objects and initliase
    // an SASDevice from each object at index.
    // Create a URL from the devices imageURL string.
    // Then download the image.
    for (int i; i < 100; i++) {
        
        
        // Get the image for the cell.
        SASDevice *deviceAtIndex = [objectsForCells objectAtIndex:i];
        
        NSString *imageURL = deviceAtIndex.imageURL;
        
        NSURL *url = [NSURL URLWithString:imageURL];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url
                                                            options:0
                                                           progress:nil
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                              if (image && finished) {
                                                                  [self.imagesForCell addObject:image];
                                                                  printf("dd");
                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayUpdated" object:nil];
                                                              }
                                                          }];
    }
    
    
}


#pragma mark CollectionView Data source
- (SASGalleryCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SASGalleryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    return cell;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
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
