//
//  SASUploadManager.h
//  Save a Selfie
//
//  Created by Stephen Fox on 22/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASUploadObject.h"

typedef NS_ENUM(NSUInteger, UploadCompletionStatus) {
  Failed, // Upload failed.
  Success, // Upload succeeded.
  InvalidObject // An invalid object was passed.
};

/**
 This class is used to upload objects to the server.
 */
@interface SASUploadManager : NSObject

typedef void (^UploadCompletionBlock)(BOOL completion);

/**
 Obtain the shared instance to upload objects to the server.
 */
+ (SASUploadManager*) sharedInstance;


/**
 Begins upload of an object to the server.
 
 @param uploadObject The object that is to be uploaded to the server, conforming to 
                     SASVerifiedUploadObject protocol
 
 @param completioBlock Calling block upon success/ failure of object upload.
 */
- (void) beginObjectUpload:(SASUploadObject <SASVerifiedUploadObject>*) uploadObject
                completion:(UploadCompletionBlock) completionBlock;
@end
