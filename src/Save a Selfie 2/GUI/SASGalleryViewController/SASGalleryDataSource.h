//
//  SASGalleryDataSource.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASNetworkManager.h"
#import "SASGalleryControllerDataSourceProtocol.h"
#import "SASGalleryCell.h"
#import "DefaultImageDownloader.h"

/**
 A data source for SASGalleryViewController.
 - The gallery should initialise an instance,
   message it to download the data from the server
   and once the completion handler has been called
   should then ask for the images with the specified range
   of images needed.
 */
@interface SASGalleryDataSource : NSObject <SASGalleryControllerDataSource>


/**
 Initialises a new SASGalleryDataSource instance. Once
 initialise the datasource will begin retrieving its
 datasource from the providided NetworkManager.
 
 @param identifier       Provided for the UICollectionViewController.
 @param networkMananager Used to download the data.
 @param worker           Used for downloading images.
 
 */
- (instancetype) initWithReuseCell:(SASGalleryCell*) reuseCell
                   reuseIdentifier:(NSString*) identifier
                    networkManager:(SASNetworkManager*) networkManager
                            worker:(id<DownloadWorker>) worker;


@end
