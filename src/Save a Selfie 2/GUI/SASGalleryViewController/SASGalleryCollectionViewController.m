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

/**
 The basic control flow of this class from
 image download to displaying to user:
 - viewDidLoad
 - downloadFromServer 
 - setupGallery.
 */

@interface SASGalleryCollectionViewController () <
UICollectionViewDelegate,
SASGalleryCellDelegate> {
  
  int imagesDownloadedCount;
}

@property (strong, nonatomic) SASNetworkManager *networkManager;
@property (strong, nonatomic) __block SASGalleryContainer *galleryContainer;
@property (strong, nonatomic) NSArray<SASDevice*> *downloadedObjects;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign,nonatomic) __block BOOL canRefresh;
@property (strong, nonatomic) SASGalleryDataSource *galleryDataSource;
@property (strong, nonatomic) SASGalleryCell *galleryCell;

@end


@implementation SASGalleryCollectionViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  
  if(!self.refreshControl) {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    
    self.refreshControl.attributedTitle = a;
    [self.collectionView addSubview:self.refreshControl];
    
  }
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
 
  if (!self.galleryDataSource) {
    self.galleryCell = [[SASGalleryCell alloc] init];
    self.galleryCell.delegate = self;
    self.galleryDataSource = [[SASGalleryDataSource alloc] initWithReuseCell:self.galleryCell reuseIdentifier:@"cell" networkManager:self.networkManager worker:[[DefaultDownloadWorker alloc] init]];
    [self.galleryDataSource downloadFromServer:^(BOOL completion) {
      if (completion) {
        self.collectionView.dataSource = self.galleryDataSource;
        [self initialSetupOfGallery];
      }
    }];
    
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
  }
  
  self.navigationItem.title = @"Gallery";
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f],
                                                                    NSForegroundColorAttributeName : [UIColor blackColor]
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


- (void) initialSetupOfGallery {
  [self showActivityIndicator];
  
  NSRange range = NSMakeRange(0, 35);
  imagesDownloadedCount = (int)range.length;
  
  
  [self.galleryDataSource imagesWithinRange:range completion:^(BOOL completion) {
    if (completion) {
      [self hideActivityIndicator];
      self.canRefresh = YES;
      [self.collectionView reloadData];
    }
    [self.collectionView reloadData];

  }];
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
    
    // Download the next 15 images.
    NSRange range = NSMakeRange(imagesDownloadedCount, imagesDownloadedCount + 15);
    imagesDownloadedCount = (int)range.length;
    
    [self showActivityIndicator];
    
    [self.galleryDataSource imagesWithinRange:range completion:^(BOOL completed) {
      if (completed) {
        [self hideActivityIndicator];
      } else {
        [self.collectionView reloadData];
      }
    }];
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

@end
