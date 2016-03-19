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
  NSArray <NSString*> *pathToImages;
  
  if (query.type == SASNetworkQueryImageDownload) {
    pathToImages = [query imagePaths];
    // If we only have on image to download.
    if (pathToImages.count == 1) {
      [self downloadImage:[pathToImages firstObject]
           withCompletion:completionBlock];
    } else if (pathToImages.count > 1) {
      [self downloadImages:pathToImages withCompletion:completionBlock];
    }
    
  }
}


// Downloads one image.
- (void) downloadImage:(NSString*) filePath withCompletion:(DownloadWorkerImageCompletionBlock) completionBlock {
  [self beginNetworkCall:filePath withCompletion:completionBlock];
}



// Downloads more than one image.
- (void) downloadImages:(NSArray<NSString*>*) filePaths withCompletion:(DownloadWorkerImageCompletionBlock) completionBlock {
  for (NSString* filePath in filePaths) {
    [self beginNetworkCall:filePath withCompletion:completionBlock];
  }
}


// Begins download of an image from the URL.
- (void) beginNetworkCall:(NSString*) filePath withCompletion:(DownloadWorkerImageCompletionBlock) completionBlock {
  [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
    NSDictionary *userInfo = [SASUser currentLoggedUser];
    NSString *token = [userInfo objectForKey:USER_DICT_TOKEN];
    NSString *tokenFormat = [NSString stringWithFormat:@"Bearer %@", token];
    
    // Append image file path to url.
    [simpleRequest setUrl:[NSString stringWithFormat:@"%@%@", GET_IMAGE_URL, filePath]];
    [simpleRequest setHeaders:@{@"Accept": @"application/json",
                                @"Content-Type": @"application/json",
                                @"Authorization": tokenFormat}];
  }] asBinaryAsync:^(UNIHTTPBinaryResponse *binaryResponse, NSError *error) {
    UIImage *image = [UIImage imageWithData:binaryResponse.body];
    completionBlock(image);
  }];
}
@end
