//
//  UploadWorker.h
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SASNetworkObject;

// Statuses concerned with upload.
typedef NS_ENUM(NSUInteger, UploadCompletionStatus) {
  UploadCompletionStatusFailed, // Upload failed.
  UploadCompletionStatusSuccess, // Upload succeeded.
};


/**
 This protocol should be implemented for uploads to a server.
 The uploading implementation is left to the conforming client.
 */
@protocol UploadWorker <NSObject>

typedef void (^UploadCompletionBlock)(UploadCompletionStatus completion);


- (void) uploadObject:(SASNetworkObject*) uploadObject
           completion:(UploadCompletionBlock)completion;

@end
