//
//  SASGalleryViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryViewController.h"
#import "SASMapAnnotationRetriever.h"
#import "SASGalleryCell.h"

@interface SASGalleryViewController () <UICollectionViewDelegate,UICollectionViewDataSource, SASMapAnnotationRetrieverDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong) SASMapAnnotationRetriever *sasMapAnnotationRetriever;
@property (nonatomic, weak) NSMutableArray *sasAnnotationsArray;

// Flag to determine whether or not data has been retrieved.
@property (nonatomic, assign) BOOL sasAnnotationsRetrieved;

@end


@implementation SASGalleryViewController

@synthesize collectionView;

@synthesize sasMapAnnotationRetriever;
@synthesize sasAnnotationsArray;
@synthesize sasAnnotationsRetrieved;

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    self.sasMapAnnotationRetriever = [[SASMapAnnotationRetriever alloc] init];
    [self.sasMapAnnotationRetriever fetchSASAnnotationsFromServer];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView reloadData];
}



#pragma SASMapAnnotationRetrieverDelegate
- (void)sasAnnotationsRetrieved:(NSMutableArray *)devices {
    self.sasAnnotationsArray = devices;
    
    self.sasAnnotationsRetrieved = YES;
}


#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.sasAnnotationsRetrieved) {
        return [self.sasAnnotationsArray count];
    }
    else {
        return 0;
        // TODO: Add something here to signify problem.
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.sasAnnotationsRetrieved) {
        return [SASGalleryCell new];
    } else {
        return [SASGalleryCell new];
    }
}



@end
