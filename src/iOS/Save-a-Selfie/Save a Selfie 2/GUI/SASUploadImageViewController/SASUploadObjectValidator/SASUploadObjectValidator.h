//
//  SASUploadObjectValidator.h
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASUploadObject.h"

typedef NS_ENUM(NSInteger, SASUploadObjectValidatorResponse) {
    SASUploadObjectTimeStampIsNil,
    SASUploadObjectAssociatedDeviceIsNil,
    SASUploadObjectCoordinatesInvalid,
    SASUploadObjectImageIsNil,
    SASUploadObjectDescriptionInvalid,
    SASUploadObjectReadyForUpload
};




// @Discussion:
// Use this class to validate an SASUploadObject before
// uploading to server.

@interface SASUploadObjectValidator : NSObject


// @Discussion:
//  Call this method to check whether the SASUploadObject instance is
//  deemed valid for upload.
//
//  An SASUploadObject is deemed valid for upload
//  when the following criteria is met:
//  Each field of the SASUploadObject instance is not null.
//  If a field is null the appropriate SASUploadObjectValidatorResponse value will be returned
//  to indicate what action may need to be taken.
+ (SASUploadObjectValidatorResponse) validateObject:(SASUploadObject*) object;

@end
