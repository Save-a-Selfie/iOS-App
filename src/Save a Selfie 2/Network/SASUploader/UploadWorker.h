//
//  UploadWorker.h
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SASUploadObject;

// Statuses concerned with upload.
typedef NS_ENUM(NSUInteger, UploadCompletionStatus) {
  Failed, // Upload failed.
  Success, // Upload succeeded.
  InvalidObject // An invalid object was passed.
};


@protocol UploadWorker <NSObject>

typedef void (^UploadCompletionBlock)(UploadCompletionStatus completion);

- (void) uploadObject:(SASUploadObject*) uploadObject
           completion:(UploadCompletionBlock)completion;

@end
