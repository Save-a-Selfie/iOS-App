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
#import "UIDevice+DeviceName.h"
#import "Screen.h"

@interface SASGalleryCollectionViewController () <SASObjectDownloaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate,
SASGalleryCellDelegate> {
    int imagesDownloaded;
}

@property (strong, nonatomic) SASObjectDownloader *sasObjectDownloader;
@property (strong, nonatomic) __block SASGalleryContainer *galleryContainer;
@property (strong, nonatomic) NSArray *downloadedObjects;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (assign,nonatomic) __block BOOL canRefresh;

@end


@implementation SASGalleryCollectionViewController

static NSString * const reuseIdentifier = @"cell";


-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    if(!self.refreshControl) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
        self.refreshControl.attributedTitle = a;

        [self.collectionView addSubview:self.refreshControl];
    }
    
    if (!self.sasObjectDownloader) {
        self.sasObjectDownloader = [[SASObjectDownloader alloc] initWithDelegate:self];
    }
    
    [self.sasObjectDownloader downloadObjectsFromServer];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Gallery";
}


- (void) refresh {
    
    printf("I want to refresh, the values is: %d\n", self.canRefresh);
    
    if (self.canRefresh) {
        self.canRefresh = NO;
        
        self.downloadedObjects = nil;
        [self.galleryContainer clear];
    
        // Calling this reloads the datasource, so no need to
        // do that here.
        [self.sasObjectDownloader downloadObjectsFromServer];
    }
    
    [self.refreshControl endRefreshing];
}


// Convenience method's for Activity Indicator animation
- (void) showActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = item;
    [self.activityIndicator startAnimating];
}


- (void) hideActivityIndicator {
    [self.activityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = nil;
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
    

    NSRange range = NSMakeRange(0, 55);
    imagesDownloaded = (int)range.length;
    
    [self showActivityIndicator];
    
    // Download a few images to fill the screen.
    [self downloadImages:objects withinRange:range completion:^(BOOL completed){
        if (completed) {
            [self hideActivityIndicator];
            
            // Initial set of images have been downloaded,
            // it is okay for the user to ask for a refresh.
            self.canRefresh = YES;
            NSLog(@"%d", self.canRefresh);
        }
    }];
    
}



#pragma mark Download Images.
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
                        count++;
                        
                        // We've downloaded all images.
                        if (count == downloadAmount) {
                            if(completion) {
                                completion(YES);
                            }
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
    
    SASDevice *device = self.downloadedObjects[indexPath.row];
    
    NSLog(@"%@", [device description]);

    UIImage *image = [self.galleryContainer imageForDevice:device];

    
    // Set the cell's image.
    cell.imageView.image = image;
    
    // Set the cell's device.
    cell.device = device;
    cell.delegate = self;
    
    return cell;
}



#pragma mark UICollectionViewLayout.
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIDeviceModel model = [UIDevice model];
    
    if (model == UIDeviceModelIphone6) {
        return CGSizeMake(62, 62);
    } else if (model == UIDeviceModelIphone6Plus) {
        return CGSizeMake(81, 81);
    } else {
        // iPhone 4, 4s, 5 etc..
        return CGSizeMake(79, 79);
    }
}




#pragma mark <SASGalleryCellDelegate>
- (void)sasGalleryCellDelegate:(SASGalleryCell *)cell wasTappedWithObject:(SASDevice *)device {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SASImageViewController *sasImageViewController = [storyboard instantiateViewControllerWithIdentifier:@"SASImageViewController"];
    
    sasImageViewController.device = device;
    sasImageViewController.downloadImage = NO;
    sasImageViewController.image = [cell.imageView.image copy];
    [self.navigationController pushViewController:sasImageViewController animated:YES];
    
}



#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = self.collectionView.contentOffset.y + self.collectionView.frame.size.height;
    
    if (bottomEdge >= self.collectionView.contentSize.height) {

        // Download the next 15 images.
        NSRange range = NSMakeRange(imagesDownloaded, imagesDownloaded + 15);
        imagesDownloaded = (int)range.length;
        
        [self showActivityIndicator];
        
        [self downloadImages:self.downloadedObjects
                 withinRange:range
                  completion:^(BOOL completed){
                      if (completed) {
                          [self hideActivityIndicator];
                      }
                  }
         ];
    }
}

@end
