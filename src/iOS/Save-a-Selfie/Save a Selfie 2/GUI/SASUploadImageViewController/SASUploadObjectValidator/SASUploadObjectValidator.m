//
//  SASUploadObjectValidator.m
//  Save a Selfie
//
//  Created by Stephen Fox on 03/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploadObjectValidator.h"

@implementation SASUploadObjectValidator



// TODO: Add more in depth checks on objects. Object simply being nil doesn't
// neccesarily mean they're `validated` for upload.
+ (SASUploadObjectValidatorResponse) validateObject:(SASUploadObject*) object {
    
    if (object.timeStamp == nil) {
        return SASUploadObjectTimeStampIsNil;
    }
    else if (object.associatedDevice == nil) {
        return SASUploadObjectAssociatedDeviceIsNil;
    }
    else if (!CLLocationCoordinate2DIsValid(object.coordinates)) {
        return SASUploadObjectCoordinatesInvalid;
    }
    else if (object.image == nil) {
        return SASUploadObjectImageIsNil;
    }
    else if (object.description == nil || [object.description isEqualToString:@""] || [object.description isEqualToString:@"Add Location Info"]) {
        return SASUploadObjectDescriptionInvalid;
    }
    else {
        return SASUploadObjectReadyForUpload;
    }
}
@end
