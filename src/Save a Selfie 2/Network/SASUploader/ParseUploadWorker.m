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
  selfie[@"t7"] = @(uploadObject.coordinates.longitude);
  selfie[@"t6"] = @(uploadObject.coordinates.latitude);
  selfie[@"t8"] = uploadObject.caption;
  selfie[@"t2"] = uploadObject.associatedDevice.deviceName;
  
  NSData *imageData = UIImageJPEGRepresentation(uploadObject.image, 1.0);
  PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
  selfie[@"t5"] = imageFile;
  

  [selfie saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
    success ? completion(Success) : completion(Failed);
  }];
  
}




@end
