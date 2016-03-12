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

@interface DefaultImageDownloader ()
@property (strong, nonatomic) SASNetworkQuery *networkQuery;
@end


@implementation DefaultImageDownloader

NSString* const GET_IMAGE_URL = @"https://guarded-mountain-99906.herokuapp.com/getFileById/";

- (void)downloadImageWithQuery:(SASNetworkQuery *)query
              completionResult:(DownloadWorkerImageCompletionBlock)completionBlock {
  NSString *pathToImage;
  if (query.type == SASNetworkQueryImageDownload) {
    pathToImage = [query imageArguments];
    self.networkQuery = query;
    [self downloadImage:completionBlock];
  }
}



- (void) downloadImage:(DownloadWorkerImageCompletionBlock) completionBlock {
  [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
    SASUser *sasUser = [SASUser currentUser];
    NSString *token = [sasUser token];
    NSString *tokenFormat = [NSString stringWithFormat:@"Bearer %@", token];
    
    // Append image file path to url.
    [simpleRequest setUrl:[NSString stringWithFormat:@"%@%@", GET_IMAGE_URL, self.networkQuery.imageArguments]];
    [simpleRequest setHeaders:@{@"Accept": @"application/json",
                                @"Content-Type": @"application/json",
                                @"Authorization": tokenFormat}];
  }]asBinaryAsync:^(UNIHTTPBinaryResponse *binaryResponse, NSError *error) {
    UIImage *image = [UIImage imageWithData:binaryResponse.body];
    completionBlock(image);
    self.networkQuery = nil;
  }];
}
@end
