//
//  SASUploaderNew.m
//  Save a Selfie
//
//  Created by Stephen Fox on 22/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "ParseUploadWorker.h"
#import "UIImage+SASImage.h"
#import <Parse.h>

@implementation ParseUploadWorker


- (void) uploadObject:(SASNetworkObject*) uploadObject
           completion:(UploadCompletionBlock)completion {
  
  PFObject *selfie = [[PFObject alloc] initWithClassName:@"Selfie"];
  selfie[@"longitude"] = @(uploadObject.coordinates.longitude);
  selfie[@"latitude"] = @(uploadObject.coordinates.latitude);
  selfie[@"info"] = uploadObject.caption;
  selfie[@"aidType"] = uploadObject.associatedDevice.deviceName;
  selfie[@"address"] = [NSNull null];
  
  NSData *imageData = UIImageJPEGRepresentation(uploadObject.image, 1.0);
  PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
  selfie[@"image"] = imageFile;
  

  [selfie saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
    success ? completion(Success) : completion(Failed);
  }];
  
}




@end
