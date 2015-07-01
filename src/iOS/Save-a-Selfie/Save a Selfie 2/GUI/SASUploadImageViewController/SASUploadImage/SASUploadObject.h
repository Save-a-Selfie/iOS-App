//
//  SASUploadImage.h
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class SASDevice;

@interface SASUploadObject : NSObject

@property(nonatomic, strong) NSString *timeStamp;
@property(nonatomic, strong) SASDevice *associatedDevice;
@property(nonatomic, assign) CLLocationCoordinate2D coordinates;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSString *description;

- (instancetype) initWithImage:(UIImage*) imageToUpload;

@end
