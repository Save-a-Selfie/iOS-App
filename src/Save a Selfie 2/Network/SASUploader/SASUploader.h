//
//  SASUploader.h
//  Save a Selfie
//
//  Created by Stephen Fox on 01/07/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SASUploadObject.h"

@class SASUploader;


typedef NS_ENUM(NSInteger, SASUploadInvalidObject) {
    SASUploadInvalidObjectCaption,     // Invalid caption for the SASUploadObject.
    SASUploadInvalidObjectDeviceType // Invalid type for SASDeviceType.
};



@protocol SASUploaderDelegate <NSObject>

@optional

// @Discussion:
//  As any object that wants to be upqloaded must conform to
//  `SASVerifiedUploadObject` protocol, it is possible the object may not be ready for
//   upload or in other words considered 'invalid'.
//   If the object initialise with this class is invalid, the delegate will be sent this
//   message containing the reason.
- (void) sasUploader:(SASUploadObject *) object invalidObjectWithResponse:(SASUploadInvalidObject) response;


- (void) sasUploaderDidBeginUploading:(SASUploader *) sasUploader;

// The SASUpload Object uploaded to the server successfully.
- (void) sasUploaderDidFinishUploadWithSuccess:(SASUploader*) sasUploader;


// Upload failed.
- (void) sasUploader:(SASUploader*) sasUploader didFailWithError:(NSError*) error;


@end




// @Discussion:
//  Use this class for uploading a SASUploadObject to the server.
@interface SASUploader : NSObject

@property (weak, nonatomic) SASUploadObject *sasUploadObject;

@property (weak, nonatomic) id <SASUploaderDelegate> delegate;

- (instancetype)initWithSASUploadObject: (SASUploadObject <SASVerifiedUploadObject>*) object;


// Uploads the SASUploadObject initialized with this class.
- (void) upload;

@end
