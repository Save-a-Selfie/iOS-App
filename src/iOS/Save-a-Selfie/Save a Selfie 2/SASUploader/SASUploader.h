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
//  Use this class for uploading a SASUploadObject to the server.

@interface SASUploader : NSObject

@property (weak, nonatomic) SASUploadObject *sasUploadObject;


- (instancetype)initWithSASUploadObject: (SASUploadObject*) object;


// Uploads the SASUploadObject initialized with this class.
- (void) upload;

@end
