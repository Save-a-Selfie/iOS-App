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
#import "SASAppCache.h"
#import "Cacheable.h"
#import "SignUpWorker.h"


/**
 This is the goto class for any interaction with the backend.
 The implementation of this class allows for clients to
 deal with both uploading and downloading of objects,
 to and from the server.
 
 See UploadWorker.h and DownloadWorker.h for more info
 for the aforementioned roles.
 
 */
@interface SASNetworkManager : NSObject


- (instancetype)init NS_UNAVAILABLE;


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


/**
 Attempts to download from the server with a query and a worker.
 Once downloaded will cache the objects to the global SASAppCache.
 
 @param query The query determinces what will be downloaded from the server.
 
 @param worker The worker is the implementation of the download.
 
 @param cache An object that implements the Cacheable interface.
              This object will be called when the network request
              has finished. It is up to the cache object to implement
              they're own caching technique.
 */
- (void) cacheableDownloadWithQuery: (SASNetworkQuery*) query
                          forWorker:(id<DownloadWorker>) worker
                              cache:(id<Cacheable>) cache;


/**
 Attempts to sign a user up to the backend.
 */
- (void) signUpWithWorker:(id<SignUpWorker>) signUpWorker
               completion:(SignUpWorkerCompletionBlock) completion;


/**
 Attempts to downloads an image from a network call
 implemented by some DownloadWorker object.
 
 @param query The query used for downloading.
 @param worker The object implementing the networking.
 @param completion A block thats called upon completion.
 
 */
- (void) downloadImageWithQuery:(SASNetworkQuery*) query
                      forWorker:(id<DownloadWorker>) worker
                     completion:(DownloadWorkerImageCompletionBlock) completion;


@end