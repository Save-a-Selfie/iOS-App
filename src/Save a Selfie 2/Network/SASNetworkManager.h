//
//  SASNetworkManager.h
//  Save a Selfie
//
//  Created by Stephen Fox on 28/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASNetworkObject.h"
#import "UploadWorker.h"
#import "DownloadWorker.h"


/**
 This is the goto class for any interaction with the backend.
 The implementation of this class allows for clients to
 deal with both uploading and downloading of objects,
 to and from the server.
 
 See UploadWorker.h and DownloadWorker.h for more info
 for the aforementioned roles.
 
 */
@interface SASNetworkManager : NSObject


/**
 Reference the shared instance to access
 networking capabilities within the application.
 */
+ (SASNetworkManager*) sharedInstance;


/**
 Begins upload of an object to the server with a worker.
 A worker must conform to the UploadWorker protocol and
 the implementation of how the upload is implemented is left
 to that class.
 
 @param worker A UploadWorker that will upload to a backend.
 
 @param uploadObject The object that is to be uploaded to the server.
 
 @param completioBlock Calling block upon success/ failure of object upload (see UploadWorker.h).
 */
- (void) uploadWithWorker: (id<UploadWorker>) worker
               withObject: (SASNetworkObject*) object
               completion: (UploadCompletionBlock) completionBlock;



/**
 Attempts to download from the server with a query and a worker.
 
 @param query The query determines what will be downloaded from
              the server.
 
 @param worker The worker is is how the downloading is implemented.
 
 @param block A DownloadWorkerCompletionBlock with the result of
              the download passed via the block
 */
- (void) downloadWithQuery: (SASNetworkQuery*) query
                 forWorker:(id<DownloadWorker>) worker
                completion:(DownloadWorkerCompletionBlock) block;

@end
