//
//  SASUploadImage.h
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SASDevice.h"


/**
 SASNetwork encapsulates all information used for uploading
 and downloading to the server.
 */
@interface SASNetworkObject : NSObject

/**
 A unique identifier string which is used by the server.
 */
@property(nonatomic, strong) NSString *identifier;

/**
 The time the object is uploaded at.
 */
@property(nonatomic, strong) NSString *timeStamp;

/**
 The associated SASDevice which gives information
 about the type of device.
 */
@property(nonatomic, strong) SASDevice *associatedDevice;

/**
 The coordinates of the object to upload.
 */
@property(nonatomic, assign) CLLocationCoordinate2D coordinates;


/**
 The image to upload.
 */
@property(nonatomic, strong) UIImage *image;

/**
 The caption the user has entered for the upload.
 */
@property(nonatomic, strong) NSString *caption;

/**
 The UUID of the user's iOS device.
 */
@property(nonatomic, strong) NSString* UUID;
 


/**
 Creates a new instance and set the image to upload.
 */
- (instancetype) initWithImage:(UIImage*) imageToUpload;



@end
