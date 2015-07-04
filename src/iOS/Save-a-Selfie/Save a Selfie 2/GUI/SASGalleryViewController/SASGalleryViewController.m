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
@property (nonatomic, weak) NSMutableArray *sasDevicesArray;

@property (nonatomic, strong) NSString *reuseIdentifier;

// Flag to determine whether or not data has been retrieved.
@property (nonatomic, assign) BOOL sasAnnotationsRetrieved;


@end


@implementation SASGalleryViewController

@synthesize collectionView;

@synthesize sasMapAnnotationRetriever;
@synthesize sasDevicesArray;
@synthesize sasAnnotationsRetrieved;

@synthesize reuseIdentifier;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    

    self.sasMapAnnotationRetriever = [[SASMapAnnotationRetriever alloc] init];
    self.sasMapAnnotationRetriever.delegate = self;
    [self.sasMapAnnotationRetriever fetchSASAnnotationsFromServer];
    
    self.reuseIdentifier = @"cell";
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SASGalleryCell" bundle:nil]
          forCellWithReuseIdentifier:self.reuseIdentifier];
}


- (void)sasAnnotationsRetrieved:(NSMutableArray *)devices {

    self.sasDevicesArray = devices;
    self.sasAnnotationsRetrieved = YES;
    
    [self.collectionView reloadData];
    printf("Reloaded");
}


#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.sasAnnotationsRetrieved) {
        NSLog(@"NumberOfItemsInSection count = %lu", (unsigned long)[self.sasDevicesArray count]);
        return [self.sasDevicesArray count];
        
    }
    else {
        return 0;
    }
}




- (SASGalleryCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SASGalleryCell *sasGalleryCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    if (self.sasAnnotationsRetrieved) {
        
        [sasGalleryCell setSasDevice:[self.sasDevicesArray objectAtIndex:indexPath.row]];
        return sasGalleryCell;
    }
    else {
        return sasGalleryCell;
    }
}

@end