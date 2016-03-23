//
//  SASGalleryCollectionViewControllerTest.m
//  Save a Selfie
//
//  Created by Stephen Fox on 10/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryCollectionViewController.h"
#import "SASGalleryContainer.h"
#import "SASDevice.h"
#import "SASGalleryCell.h"
#import "SASImageViewController.h"
#import "UIDevice+DeviceName.h"
#import "Screen.h"
#import "FXAlert.h"
#import "SASNetworkManager.h"
#import "DefaultDownloadWorker.h"
#import "SASGalleryDataSource.h"



@interface SASGalleryCollectionViewController () <
UICollectionViewDelegate,
SASGalleryCellDelegate> {
  
  int imagesDownloadedCount;
  int imagesToDownload;
}

@property (strong, nonatomic) SASNetworkManager *networkManager;
@property (strong, nonatomic) __block SASGalleryContainer *galleryContainer;
@property (strong, nonatomic) NSArray<SASDevice*> *downloadedObjects;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign,nonatomic) __block BOOL canRefresh;
@property (strong, nonatomic) SASGalleryDataSource *galleryDataSource;
@property (strong, nonatomic) SASGalleryCell *galleryCell;
@property (strong, nonatomic) NSMutableArray <SASDevice*> *devices;
@property (strong, nonatomic) NSMutableArray <NSString *> *filePaths;
@property (assign, nonatomic) NSRange currentDownloadRange;
@property (assign, nonatomic) BOOL allImagesDownloaded;
@property (assign, nonatomic) BOOL currentlyDownloading;

@end


@implementation SASGalleryCollectionViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self showActivityIndicator];
  [self beginDownloadProcess];
  
  if(!self.refreshControl) {
    self.refreshControl = [[UIRefreshControl alloc] init];
    //[self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    
    self.refreshControl.attributedTitle = a;
    //[self.collectionView addSubview:self.refreshControl];
    
  }
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.collectionView.delegate = self;
  self.collectionView.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = @"Gallery";
  [self.navigationController.navigationBar
   setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f],
                            NSForegroundColorAttributeName : [UIColor blackColor] }];

}




- (void) beginDownloadProcess {
  self.currentDownloadRange = NSMakeRange(0, 0);
  [self downloadDevices];
  if (!self.galleryDataSource) {
    self.galleryCell = [[SASGalleryCell alloc] init];
    self.galleryCell.delegate = self;
    self.galleryDataSource = [[SASGalleryDataSource alloc]
                              initWithReuseCell:self.galleryCell
                              reuseIdentifier:@"cell"
                              networkManager:self.networkManager worker:[DefaultImageDownloader new]];
    self.collectionView.dataSource = self.galleryDataSource;
  }
}


// When we first begin downloading we must
// download all the devices from the server first.
// We need to do this as when a user clicks on an images
// we want to be able to present -SASImageViewController
// and show all the data associated with the image downloaded.
- (void) downloadDevices {
  // We want to download all the devices from the
  // server as we can.
  DefaultDownloadWorker *downloadWorker = [[DefaultDownloadWorker alloc] init];
  SASNetworkQuery *query = [[SASNetworkQuery alloc] init];
  query.type = SASNetworkQueryTypeAll; // Download all devices.
  
  if (!self.networkManager) {
    self.networkManager = [SASNetworkManager sharedInstance];
  }
  
  // Go dowload the devices from the server.
  [self.networkManager downloadWithQuery:query forWorker:downloadWorker completion:^(NSArray<SASDevice *> *result) {
    dispatch_async(dispatch_get_main_queue(), ^{
      // Keep reference to all devices downloaded.
      self.devices = [result mutableCopy];
      
      // Once downloaded extract filePaths
      [self extractFilePathsFromDevices:self.devices];
      
      [self downloadImages];
    });
  }];
}



- (void) extractFilePathsFromDevices:(NSArray <SASDevice*>*) devices {
  if (!self.filePaths) {
    self.filePaths = [[NSMutableArray alloc] init];
  }
  
  // Get all the filePaths so we can give them to the datasource
  // for downloading.
  for (SASDevice *device in devices) {
    [self.filePaths addObject:device.filePath];
  }
}


- (NSRange) determineNextRangeForImageDownload:(unsigned int) totalElements
                              withCurrentRange:(NSRange) range
                            desiredRangeLength:(unsigned int) desiredLength {
  if (!(range.location >= totalElements)) {
    if ((range.location + desiredLength) >= totalElements) {
      return NSMakeRange(range.location, totalElements - range.location);
    }
    else {
      return NSMakeRange(range.location, range.location + desiredLength);
    }
  } else {
    return NSMakeRange(0, 0);
  }
}


- (void) showGalleryAlery:(NSString*) message {
  FXAlertController *galleryAlert = [[FXAlertController alloc] initWithTitle:@"Error" message: message];
  FXAlertButton *okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeCancel];
  [okButton setTitle:@"Ok" forState:UIControlStateNormal];
  [galleryAlert addButton:okButton];
  [self presentViewController:galleryAlert animated:YES completion:nil];
}


- (void) downloadImages {
  if (!self.filePaths || self.filePaths.count == 0) {
    [self showGalleryAlery:@"Could not load gallery."];
    return;
  }
  // All images available have been downloaded.
  if (self.allImagesDownloaded) {
    return;
  }
  // If we already downloading ignore any new requests.
  if (self.currentlyDownloading) {
    return;
  }
  self.currentDownloadRange = NSMakeRange(imagesDownloadedCount, 0);
  self.currentDownloadRange = [self determineNextRangeForImageDownload:(int)self.filePaths.count
                                                      withCurrentRange:self.currentDownloadRange
                                                    desiredRangeLength:30];
  
  if (self.currentDownloadRange.location == 0 && self.currentDownloadRange.length == 0) {
    return;
  }
  
  // We don't want to download every omage on the server
  // only just the amount specified within the range so make
  // a sub array of these filepaths.
  NSArray<SASDevice*> *subArrayOfDevices = [self.devices subarrayWithRange:self.currentDownloadRange];
  
  // Query for the datasource to use.
  SASNetworkQuery *query = [[SASNetworkQuery alloc] init];
  [query setDevices: subArrayOfDevices];
  query.type = SASNetworkQueryImageDownload;
  self.currentlyDownloading = YES;
  
  [self.galleryDataSource imagesWithQuery:query completion:^(BOOL finished, SASDevice *sasDevice) {
    if (finished) {
      [self hideActivityIndicator];
      self.canRefresh = YES;
      [self.collectionView reloadData];
      imagesDownloadedCount += 1;
      self.currentlyDownloading = NO;
    } else {
      // The complete load of the gallery may
      // not be finished, however another image
      // may be loaded.
      [self.collectionView reloadData];
      imagesDownloadedCount += 1;
    }

    
    if (imagesDownloadedCount >= self.filePaths.count) {
      self.allImagesDownloaded = YES;
    }
  }];
}


- (void) refresh {
  if (self.canRefresh) {
    self.canRefresh = NO;
    self.downloadedObjects = nil;
    [self.galleryContainer clear];
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
    return CGSizeMake(30, 30);
  } else if (model == UIDeviceModelIphone6Plus) {
    return CGSizeMake(81, 81);
  } else {
    // iPhone 4, 4s, 5 etc..
    return CGSizeMake(79, 79);
  }
}




#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  float bottomEdge = self.collectionView.contentOffset.y + self.collectionView.frame.size.height;
  
  if (bottomEdge >= self.collectionView.contentSize.height) {
    [self downloadImages];
  }
}

#pragma mark <SASGalleryCellDelegate>
- (void)sasGalleryCellDelegate:(SASGalleryCell *)cell wasTappedWithObject:(SASDevice *)device {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  SASImageViewController *sasImageViewController = [storyboard instantiateViewControllerWithIdentifier:@"SASImageViewController"];
  
  sasImageViewController.device = device;
  sasImageViewController.downloadImage = NO;
  sasImageViewController.image = [cell.imageView.image copy];
  
  SASAnnotation *a = [SASAnnotation annotationWithSASDevice:device];
  sasImageViewController.annotation = a;
  
  
  [self.navigationController pushViewController:sasImageViewController animated:YES];
}



@end
