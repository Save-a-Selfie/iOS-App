//
//  SASGalleryViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 11/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryCollectionViewController.h"
#import "SASGalleryCell.h"
#import "SASMapAnnotationRetriever.h"
#import "SASImageViewController.h"
#import "SASUtilities.h"

#define CELL_LIMIT 30

@interface SASGalleryCollectionViewController() <SASMapAnnotationRetrieverDelegate, SASGalleryCellDelegate>

@property(strong, nonatomic) SASMapAnnotationRetriever *sasAnnotationRetriever;
@property(strong, nonatomic) NSMutableArray *dataForCells;
@property(strong, atomic) __block NSMutableArray *cellImages;

@end


@implementation SASGalleryCollectionViewController

@synthesize sasAnnotationRetriever;
@synthesize dataForCells;
@synthesize cellImages;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.topItem.title = @"Gallery";
    
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.cellImages = [[NSMutableArray alloc] init];
    
    
    if (self.sasAnnotationRetriever == nil) {
        self.sasAnnotationRetriever = [[SASMapAnnotationRetriever alloc] init];
        self.sasAnnotationRetriever.delegate = self;
    }
    
    [self.sasAnnotationRetriever fetchSASAnnotationsFromServer];
    
}


- (void)sasAnnotationsRetrieved:(NSMutableArray *)devices {
    self.dataForCells = devices;
    NSLog(@"%ld", devices.count);
    [self.collectionView reloadData];
}



#pragma mark CollectionView Data source
- (SASGalleryCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the image for the cell.
    __weak SASDevice *deviceAtIndex = [self.dataForCells objectAtIndex:indexPath.row];
    
    __weak NSString *imageURL = deviceAtIndex.imageURL;
    
    
    __block SASGalleryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage *image = [UIImage imageWithData:data];
        if (image != nil) {
            [self.cellImages addObject:image];
        }

        NSLog(@"%lu", (unsigned long) self.cellImages.count);
        if(cellImages.count == 28) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = [self.cellImages objectAtIndex:indexPath.row];
                cell.device = [self.dataForCells objectAtIndex:indexPath.row];
            });
        };
    });
    
    return cell;
    
}


- (void) setCells {
             
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 28;
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
