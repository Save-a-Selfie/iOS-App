//
//  SASUploaderNew.h
//  Save a Selfie
//
//  Created by Stephen Fox on 22/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASUploadObject.h"
#import "SASUploadManager.h"

/**
 This class uploads manages uploading to the Parse Server.
 to a Parse server.
 */
@interface ParseUploadWorker : NSObject <UploadWorker>

/**
 Uploads a SASUploadObject to the Parse server.
 */
- (void) uploadObject:(SASUploadObject*) uploadObject
           completion:(UploadCompletionBlock)completion;

@end
