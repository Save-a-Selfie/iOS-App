//
//  SASUploadManager.h
//  Save a Selfie
//
//  Created by Stephen Fox on 22/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASUploadObject.h"
#import "UploadWorker.h"



/**
 This class is used to upload objects to the server.
 */
@interface SASUploadManager : NSObject



/**
 Obtain the shared instance to upload objects to the server.
 */
+ (SASUploadManager*) sharedInstance;


/**
 Begins upload of an object to the server with a worker.
 A worker must conform to the UploadWorker protocol and
 the implementation of how the upload is implemented is left
 to that class.
 
 @param worker A UploadWorker that will upload to a backend.
 
 @param uploadObject The object that is to be uploaded to the server, conforming to 
                     SASVerifiedUploadObject protocol
 
 @param completioBlock Calling block upon success/ failure of object upload (see UploadWorker.h).
 */
- (void) uploadWorker: (id<UploadWorker>) worker
           withObject: (SASUploadObject <SASVerifiedUploadObject>*) uploadObject
           completion: (UploadCompletionBlock) completionBlock;
@end
