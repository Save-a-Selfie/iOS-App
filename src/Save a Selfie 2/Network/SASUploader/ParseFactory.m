//
//  ParseFactory.m
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "ParseFactory.h"



@implementation ParseFactory

+ (ParseFactory *)sharedInstance {
  static ParseFactory *sharedInstance;
  static dispatch_once_t token;
  
  dispatch_once(&token, ^(){
      sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (PFObject*) createUploadObject:(SASUploadObject*) uploadObject {
  PFObject *pfObject = [[PFObject alloc] initWithClassName:@"PFUploadObject"];
  pfObject[@"longtitude"] = @(uploadObject.longtitude);
  pfObject[@"latitude"] = @(uploadObject.latitude);
  pfObject[@"info"] = uploadObject.caption;
  pfObject[@"aidType"] = uploadObject.associatedDevice.deviceName;
  pfObject[@"address"] = [NSNull null];
  
  NSData *imageData = UIImageJPEGRepresentation(uploadObject.image, 1.0);
  PFFile *imageFile = [PFFile fileWithData:imageData];
  pfObject[@"image"] = imageFile;
  
  return pfObject;
}


@end
