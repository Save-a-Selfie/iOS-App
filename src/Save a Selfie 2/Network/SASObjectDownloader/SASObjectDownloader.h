//
//  SASObjectDownloader.h
//  Save a Selfie
//
//  Created by Stephen Fox on 28/05/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SASObjectDownloader;


@protocol SASObjectDownloaderDelegate <NSObject>

/**
 This method is called when all objects from the server have been downloaded.
 The term `objects` refers to an array of SASDevices that have been initialised with
 an info string retrieved from the server. Each device encapsulates information such
 as the coordinates from where it was taken an image url and more. See SASDevice.h for
 full info.
 
 @param downloader An instance of SASObjectDownloader responsible for messaging
                   the delegate.
 @param  onbjects  An array of SASDevices retrieved from the server.
 */
- (void) sasObjectDownloader:(SASObjectDownloader *) downloader didDownloadObjects: (NSArray*) objects;

@optional
/**
 This method simply passes on the error that occured.
 */
- (void) sasObjectDownloader:(SASObjectDownloader *) downloader didFailWithError: (NSError *) error;

@end


/**
 Use this class to fetch/download objects from the server(SASDevices).
 */
@interface SASObjectDownloader : NSObject

/**
 Initialises a new instance with the delegate set.
 
 @param delegate Sets the delegate.
 */
- (instancetype) initWithDelegate:(id) delegate;


/**
 Sets the delegate.
 */
@property(nonatomic, weak) id<SASObjectDownloaderDelegate> delegate;

/**
 This method downloads all the information from the server 
 which is then constructed into an NSArray of SASDevice's.
 Once all the information is downloaded and the SASDevices are
 constructed they are passed via the SASObjectDownloaderDelegate method:
    - sasObjectDownloader: didDownloadObjects:
 */
- (void) downloadObjectsFromServer;

/**
 Returns a UIImage from a string containing a url.
 Note: This method is not called on the main thread.
 
 @return UIImage The image from the url.
 */
- (UIImage*) getImageFromURLWithString: (NSString *) string;

@end
