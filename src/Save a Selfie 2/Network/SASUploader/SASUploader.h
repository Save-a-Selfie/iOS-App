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
    SASUploadInvalidObjectDeviceType,  // Invalid type for SASDeviceType.
    SASUploadInvalidObjectCoordinates // Invalid Coordinates given.
};



@protocol SASUploaderDelegate <NSObject>

@optional

/**
 If the object that is trying to be uploaded doesn't pass correct checks
 via the SASVerifiedUploadObject protocol this method will pass to the delegate
 any information regarding problems that have occurred.
 
 @param object      The object attempting to be uploaded.
 @param response    The problem that has occurred regarding
                    the appropriate checks being made before upload.
 */
- (void) sasUploader:(SASUploadObject *) object invalidObjectWithResponse:(SASUploadInvalidObject) response;


/**
 This method will be called when the upload has begun
 
 @sasUploader The delegator.
 */
- (void) sasUploaderDidBeginUploading:(SASUploader *) sasUploader;

/**
 When the SASUpload object for the instance been uploaded
 this method is called.
 
 @param The delegator
 */
- (void) sasUploaderDidFinishUploadWithSuccess:(SASUploader*) sasUploader;


/**
 Uploading has failed.
 
 @param sasUploader The delegator.
 @param error       The error that has occurred.
 */
- (void) sasUploader:(SASUploader*) sasUploader didFailWithError:(NSError*) error;


@end





/** 
 Use this class for uploading a SASUploadObject to the server.
 */
@interface SASUploader : NSObject

/**
 The SASUploadObject that was initiliased with the instance.
 */
@property (weak, readonly) SASUploadObject<SASVerifiedUploadObject> *sasUploadObject;


@property (weak, nonatomic) id <SASUploaderDelegate> delegate;


/**
 Initialises a new instance with a SASUploadObject.
 
 @param object       An SASUploadObject instance that conforms to SASVerifiedUploadObject
                     protocol. This protocol allows for specific checks to be made
                     before the object is uploaded.
 
 @return SASUploader A new instance.
 */
- (instancetype)initWithSASUploadObject: (SASUploadObject <SASVerifiedUploadObject>*) object;


/**
 Uploads the sasUploadObject initialised with the class to the server.
 The sasUploadObject is uploaded after all checks are made.
 Callbacks for this method are done through SASUploader delegate.
 */
- (void) upload;

@end
