//
//  DefaultImageDownloader.m
//  Save a Selfie
//
//  Created by Stephen Fox on 12/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "DefaultImageDownloader.h"
#import <UNIRest.h>
#import "SASUser.h"



@implementation DefaultImageDownloader

NSString* const GET_IMAGE_URL = @"https://guarded-mountain-99906.herokuapp.com/getFileById/";

- (void)downloadImageWithQuery:(SASNetworkQuery *)query
              completionResult:(DownloadWorkerImageCompletionBlock)completionBlock {
  NSArray <SASDevice*> *imagesToDownload;
  
  if (query.type == SASNetworkQueryImageDownload) {
    imagesToDownload = [query devices];
    // If we only have on image to download.
    if (imagesToDownload.count == 1) {
      [self downloadImage:[imagesToDownload firstObject]
           withCompletion:completionBlock];
    } else if (imagesToDownload.count > 1) {
      [self downloadImages:imagesToDownload withCompletion:completionBlock];
    }
    
  }
}


// Downloads one image.
- (void) downloadImage:(SASDevice*) device withCompletion:(DownloadWorkerImageCompletionBlock) completionBlock {
  [self beginNetworkCall:device withCompletion:completionBlock];
}



// Downloads more than one image.
- (void) downloadImages:(NSArray<SASDevice*>*) devices withCompletion:(DownloadWorkerImageCompletionBlock) completionBlock {
  for (SASDevice* device in devices) {
    [self beginNetworkCall:device withCompletion:completionBlock];
  }
}


// Begins download of an image from the URL.
- (void) beginNetworkCall:(SASDevice*) sasDevice withCompletion:(DownloadWorkerImageCompletionBlock) completionBlock {
  [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
    NSDictionary *userInfo = [SASUser currentLoggedUser];
    NSString *token = [userInfo objectForKey:USER_DICT_TOKEN];
    NSString *tokenFormat = [NSString stringWithFormat:@"Bearer %@", token];
    
    // Append image file path to url.
    [simpleRequest setUrl:[NSString stringWithFormat:@"%@%@", GET_IMAGE_URL, sasDevice.filePath]];
    [simpleRequest setHeaders:@{@"Authorization": tokenFormat}];
  }] asBinaryAsync:^(UNIHTTPBinaryResponse *binaryResponse, NSError *error) {
      completionBlock(binaryResponse.body, sasDevice);
  }];
}
@end
