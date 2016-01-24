//
//  PFUploadObject.h
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse.h>

/**
 The PFUpload object is to be used to upload data to
 Parse, this is modelled exactly how it is represented
 on the backend.
 */
@interface PFUploadObject : NSObject

@property(nonatomic, strong) PFFile *image;

@property(nonatomic, assign) CLLocationDegrees *longitude;

@property(nonatomic, assign) CLLocationDegrees *latitude;

@property(nonatomic, assign) NSString *info;

@property(nonatomic, strong) NSString *aidType;

@property(nonatomic, strong) NSString *address;


@end
