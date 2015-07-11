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
    
    self.navigationController.navigationBarHidden = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGSize size = self.collectionView.bounds.size;
    
    layout.itemSize = CGSizeMake(size.width, size.height);
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    layout.minimumLineSpacing = 0;
    
    layout.headerReferenceSize = CGSizeMake(0.0, 0);

    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    

    self.sasMapAnnotationRetriever = [[SASMapAnnotationRetriever alloc] init];
    self.sasMapAnnotationRetriever.delegate = self;
    [self.sasMapAnnotationRetriever fetchSASAnnotationsFromServer];
    
    self.reuseIdentifier = @"cell";
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SASGalleryCell" bundle:nil]
          forCellWithReuseIdentifier:self.reuseIdentifier];
}


#pragma mark SASMapAnnotationRetriever Delegate
- (void)sasAnnotationsRetrieved:(NSMutableArray *)devices {

    self.sasDevicesArray = devices;
    self.sasAnnotationsRetrieved = YES;
    
    [self.collectionView reloadData];
}




#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.sasAnnotationsRetrieved) {
        return [self.sasDevicesArray count];
        
    }
    else {
        return 0;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}




- (SASGalleryCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SASGalleryCell *sasGalleryCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    
    if (self.sasAnnotationsRetrieved) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            SASDevice* deviceFromIndex = [self.sasDevicesArray objectAtIndex:indexPath.row];
            NSString* deviceImageURLSring = deviceFromIndex.imageURL;
            
            
            
            UIImage* imageObjectFromURL = [self.sasMapAnnotationRetriever getImageFromURLWithString:deviceImageURLSring];
           
           dispatch_async(dispatch_get_main_queue(), ^{
               sasGalleryCell.sasDevice = deviceFromIndex;
               
               sasGalleryCell.imageView.image = imageObjectFromURL;
           
           });
        
       });
        return sasGalleryCell;
    }
    else {
        return sasGalleryCell;
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10; // This is the minimum inter item spacing, can be more
}

@end