//
//  SASVerifiedUploadObject.h
//  Save a Selfie
//
//  Created by Stephen Fox on 09/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SASUploadObject;

// Objects that will be uploaded to the server must conform to this protocol
// and implement the methods. This allows for correct checks to be made before
// uploading.
@protocol SASVerifiedUploadObject <NSObject>

- (BOOL) captionHasBeenSet;

- (BOOL) deviceHasBeenSet;

@end