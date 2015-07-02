//
//  SASUploader.h
//  Save a Selfie
//
//  Created by Stephen Fox on 01/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SASUploadObject.h"

// @Discussion:
//  Use this class for uploading a SASUpload object to the server.

@interface SASUploader : NSObject

@property (strong, nonatomic) SASUploadObject *sasUploadObject;

@end
