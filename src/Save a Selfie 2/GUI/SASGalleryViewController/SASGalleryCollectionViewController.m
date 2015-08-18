//
//  SASGalleryCollectionViewControllerTest.m
//  Save a Selfie
//
//  Created by Stephen Fox on 10/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryCollectionViewController.h"
#import "SASObjectDownloader.h"
#import "SASGalleryContainer.h"
#import "SASDevice.h"
#import <SDWebImageDownloader.h>
#import "SASGalleryCell.h"
#import "SASImageViewController.h"
#import "SASActivityIndicator.h"

@interface SASGalleryCollectionViewController () <SASObjectDownloaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate,
SASGalleryCellDelegate> {
    int imagesDownloaded;
}

@property (strong, nonatomic) SASObjectDownloader *sasObjectDownloader;
@property (strong, nonatomic) __block SASGalleryContainer *galleryContainer;
@property (strong, nonatomic) NSArray *downloadedObjects;
@property (strong, nonatomic) SASActivityIndicator *activityIndicator;

@end


@implementation SASGalleryCollectionViewController

static NSString * const reuseIdentifier = @"cell";


-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    if (!self.sasObjectDownloader) {
        self.sasObjectDownloader = [[SASObjectDownloader alloc] initWithDelegate:self];
    }
    
    if (!self.activityIndicator) {
        self.activityIndicator = [[SASActivityIndicator alloc] initWithMessage:@"Loading..."];
        self.activityIndicator.center = self.collectionView.center;
        [self.activityIndicator startAnimating];
        [self.collectionView addSubview:self.activityIndicator];
    }
    
    [self.sasObjectDownloader downloadObjectsFromServer];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Gallery";
}


#pragma mark <SASObjectDownladerDelegate>
- (void)sasObjectDownloader:(SASObjectDownloader *)downloader didDownloadObjects:(NSMutableArray *)objects {
    
    if(!self.downloadedObjects) {
        self.downloadedObjects = [NSArray new];
    }
    self.downloadedObjects = objects;
    
    // Set up our data store.
    if (!self.galleryContainer) {
        self.galleryContainer = [[SASGalleryContainer alloc] init];
    }
    
    NSRange range = NSMakeRange(0, 24);
    imagesDownloaded = (int)range.length;
    
    // Download a few images to fill the screen.
    [self downloadImages:objects withinRange:range completion:nil];
}





- (void) downloadImages:(NSArray *) objects withinRange:(NSRange) range completion:(void(^)(BOOL completed)) completion {
    
    __block int downloadAmount = (int)range.length - (int)range.location;
    __block int count = 0;
    
    for (int i = (int)range.location; i < (int)range.length; ++i) {
        if (!(i >= objects.count)) {
            
            SASDevice *deviceAtIndex = [objects objectAtIndex:i];
            
            NSString *imageURLString = deviceAtIndex.imageURL;
            
            NSURL *url =[NSURL URLWithString:imageURLString];
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (image && finished) {
                    
                    
                    [self.galleryContainer addImage:image forDevice:deviceAtIndex];
                    
                    // This must be called on the main thread.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                        downloadAmount++;
                        count++;
                        
                        printf("{Count = %d\n Download Amount: %d}\n", count, downloadAmount);
                        if (count == downloadAmount) {
                            
                        }
                    });
                }
            }];
        }
    }
}








#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.galleryContainer deviceCount];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SASGalleryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Set the cell's image.
    SASDevice *device = self.downloadedObjects[indexPath.row];
    
    cell.imageView.image = [self.galleryContainer imageForDevice:device];

    // Set the cell's device.
    cell.device = device;
    cell.delegate = self;
    
    return cell;
}


#pragma mark <SASGalleryCellDelegate>
- (void)sasGalleryCellDelegate:(SASGalleryCell *)cell wasTappedWithObject:(SASDevice *)device {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SASImageViewController *sasImageViewController = [storyboard instantiateViewControllerWithIdentifier:@"SASImageViewController"];
    
    sasImageViewController.device = device;
    [self.navigationController pushViewController:sasImageViewController animated:YES];
    
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


#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = self.collectionView.contentOffset.y + self.collectionView.frame.size.height;
    if (bottomEdge >= self.collectionView.contentSize.height) {

        // Download the next 15 images.
        NSRange range = NSMakeRange(imagesDownloaded, imagesDownloaded + 15);
        imagesDownloaded = (int)range.length;
        
        [self downloadImages:self.downloadedObjects withinRange:range completion:^(BOOL c){printf("gototot");}];
    }
}

@end
