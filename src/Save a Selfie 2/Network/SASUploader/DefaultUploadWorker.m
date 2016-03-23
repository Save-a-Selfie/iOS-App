//
//  DefaultUploadWorker.m
//  Save a Selfie
//
//  Created by Stephen Fox on 12/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "DefaultUploadWorker.h"
#import <UNIRest.h>
#import <AFNetworking.h>
#import "SASUser.h"
#import "SASNetworkObject.h"
#import "SASLocation.h"
#import "SASJSONParser.h"

@interface DefaultUploadWorker ()

@property(strong, nonatomic) NSString *postCode;

@end

@implementation DefaultUploadWorker


NSString* const UPLOAD_IMAGE_URL  = @"https://guarded-mountain-99906.herokuapp.com/uploadSelfie";


- (void)uploadObject:(SASNetworkObject *)uploadObject
          completion:(UploadCompletionBlock)completion {
  [self upload:uploadObject completion:completion];}

- (void)upload:(SASNetworkObject *)uploadObject completion:(UploadCompletionBlock)completion {
  // Get the current user's token.
  NSDictionary *userInfo = [SASUser currentLoggedUser];
  NSString *token = [userInfo objectForKey:USER_DICT_TOKEN];
  // Set to correct format for Authorization HTTP header.
  NSString *tokenFormat = [NSString stringWithFormat:@"Bearer %@", token];
  
  NSNumber *lat = [NSNumber numberWithDouble:uploadObject.coordinates.latitude];
  NSNumber *long_ = [NSNumber numberWithDouble:uploadObject.coordinates.longitude];
  NSString *aidType = [SASDevice getDeviceNameForDeviceType:uploadObject.associatedDevice.type];
  
  NSData *imageData = UIImageJPEGRepresentation(uploadObject.image, 0.1f);
  
  NSDictionary *jsonPost = @{@"lat" : lat,
                             @"lng": long_,
                             @"add": @"",
                             @"aid_type": aidType,
                             @"postal_code": @"",
                             @"description": uploadObject.caption};
  
  AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager]
                                            initWithBaseURL:[NSURL URLWithString:@"https://guarded-mountain-99906.herokuapp.com"]];
  [manager.requestSerializer setValue:tokenFormat forHTTPHeaderField:@"Authorization"];
  [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
  
  AFHTTPRequestOperation *op = [manager POST:@"/uploadSelfie"
                                  parameters:jsonPost
                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData
                                name:@"file"
                            fileName:@"upload_image.jpg"
                            mimeType:@"image/jpeg"];
    
  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSInteger insertStatus = [SASJSONParser parseInsertStatus:responseObject];
    
    if (insertStatus == 302) {
      completion(UploadCompletionStatusSuccess);
    } else {
      completion(UploadCompletionStatusFailed);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    completion(UploadCompletionStatusFailed);
  }];
  [op start];
}



@end
