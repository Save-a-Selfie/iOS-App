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


- (void) uploadObject:(SASUploadObject*) uploadObject completion:(UploadCompletionBlock)completion {
  
  PFObject *pfObject = [[PFObject alloc] initWithClassName:@"Selfie"];
  pfObject[@"longtitude"] = @(uploadObject.longtitude);
  pfObject[@"latitude"] = @(uploadObject.latitude);
  pfObject[@"info"] = uploadObject.caption;
  pfObject[@"aidType"] = uploadObject.associatedDevice.deviceName;
  pfObject[@"address"] = [NSNull null];
  
  NSData *imageData = UIImageJPEGRepresentation(uploadObject.image, 1.0);
  PFFile *imageFile = [PFFile fileWithData:imageData];
  pfObject[@"image"] = imageFile;
  
  [pfObject saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
    completion(success);
  }];
  
}




@end
