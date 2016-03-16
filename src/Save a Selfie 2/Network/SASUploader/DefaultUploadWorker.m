//
//  DefaultUploadWorker.m
//  Save a Selfie
//
//  Created by Stephen Fox on 12/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "DefaultUploadWorker.h"
#import <UNIRest.h>
#import "SASUser.h"
#import "SASNetworkObject.h"
#import "SASLocation.h"

@interface DefaultUploadWorker ()

@property(strong, nonatomic) NSString *postCode;

@end

@implementation DefaultUploadWorker


NSString* const UPLOAD_IMAGE_URL  = @"https://guarded-mountain-99906.herokuapp.com/uploadSelfie/";


- (void)uploadObject:(SASNetworkObject *)uploadObject
          completion:(UploadCompletionBlock)completion {
  
  // Get the postal code of upload.
  [self reverseGeolocation:uploadObject.coordinates response:^(NSString *postalCode) {
    self.postCode = postalCode;
    [self upload:uploadObject completion:completion];
  }];

}



- (void) upload:(SASNetworkObject*) uploadObject completion:(UploadCompletionBlock) completion {
  [[UNIRest post:^(UNISimpleRequest *simpleRequest) {
    NSDictionary *userInfo = [SASUser currentLoggedUser];
    NSString *token = [userInfo objectForKey:USER_DICT_TOKEN];
    NSString *tokenFormat = [NSString stringWithFormat:@"Bearer %@", token];
    
    
    NSURL *imageFile = [self generateFileForPOST:uploadObject.image];


    
    NSNumber *lat = [NSNumber numberWithDouble:uploadObject.coordinates.latitude];
    NSNumber *long_ = [NSNumber numberWithDouble:uploadObject.coordinates.longitude];
    NSString *aidType = [SASDevice getDeviceNameForDeviceType:uploadObject.associatedDevice.type];
    
    [simpleRequest setHeaders:@{@"Accept": @"application/json",
                                @"Content-Type": @"application/json",
                                @"Authorization": tokenFormat}];
    
    [simpleRequest setUrl:UPLOAD_IMAGE_URL];
    [simpleRequest setParameters:@{@"lat" : lat,
                                   @"lng": long_,
                                   @"aid_type": aidType,
                                   @"description": uploadObject.caption,
                                   @"postal_code": self.postCode,
                                   @"file": imageFile}];
  }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
    NSLog(@"ds");
  }];
}

// Reverse geocode and get the location of the upload.
- (void) reverseGeolocation:(CLLocationCoordinate2D) coordinates response:(void(^)(NSString*)) postalCode {
  __block SASLocation *location = [[SASLocation alloc] init];
  [location beginReverseGeolocationUpdate:coordinates withUpdate:^(CLPlacemark *placeMark, NSError *error) {
    if (!error) {
      postalCode(placeMark.postalCode);
      location = nil;
    }
  }];
}



// http://stackoverflow.com/questions/19380980/send-image-as-a-binary-file-to-the-server
- (NSURL*) generateFileForPOST:(UIImage*) image {
  // Get the path to the Documents folder
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentDirectoryPath = [paths objectAtIndex:0];
  
  // Get the path to an file named "tmp_image.jpg" in the Documents folder
  NSString *imagePath = [documentDirectoryPath stringByAppendingPathComponent:@"tmp_image.jpg"];
  NSURL *imageURL = [NSURL fileURLWithPath:imagePath];
  
  // Write the image to an file called "tmp_image.jpg" in the Documents folder
  NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
  [imageData writeToURL:imageURL atomically:YES];
  return imageURL;
}


@end
