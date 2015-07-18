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


// @Discussion
//  This method will pass
//  a NSMutableArray with information regarding all the devices
//  that have been uploaded.
//
//  @param device: NSMutable array which contains device information.
- (void) sasObjectDownloader:(SASObjectDownloader *) downloader didDownloadObjects: (NSMutableArray*) objects;

@end



// This class will allow us to fetch/ retrieve MKMapAnnotations.
// This app uses Device.h/.m to wrap up extra information about the device
// i.e image, location etc...
// For more information refer to Device.h.
@interface SASObjectDownloader : NSObject


@property(nonatomic, weak) id<SASObjectDownloaderDelegate> delegate;

// @Discussion:
//  Fetches and downloader all the object information
//  from the server again. The downloaded data is then
//  passed via the delegate -sasObjectDownloader: didDowloadObjects:
- (void) downloadObjectsFromServer;


// @Abstract:
//  This method gets the images from the URL off the main thread.
//  It is called inside `dispatch_async` on the global_queue.
// @return UIImage from the `URL`
- (UIImage*) getImageFromURLWithString: (NSString *) string;

@end
