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

@interface SASUploaderNew : NSObject

/**
 Uploads a SASUploadObject to the backend.
 */
- (void) uploadObject:(SASUploadObject*) uploadObject completion:(UploadCompletionBlock)completion;

@end
