//
//  SASNetworkManager.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASNetworkManager.h"


@implementation SASNetworkManager


+ (SASNetworkManager *)sharedInstance {
  static SASNetworkManager *sharedInstance;
  static dispatch_once_t token;
  
  dispatch_once(&token, ^(){
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}


- (void)uploadWithWorker:(id<UploadWorker>)worker
              withObject:(SASNetworkObject *)object
              completion:(UploadCompletionBlock ) completionBlock {
  [worker uploadObject:object completion:completionBlock];
}


- (void)downloadWithQuery:(SASNetworkQuery *)query
                forWorker:(id<DownloadWorker>)worker
               completion:(DownloadWorkerCompletionBlock) block {
  [worker downloadWithQuery:query completionResult:block];
}



- (void)cacheableDownloadWithQuery:(SASNetworkQuery *)query
                         forWorker:(id<DownloadWorker>)worker
                             cache:(id<Cacheable>)cache {
  [worker downloadWithQuery:query completionResult:^(NSArray *result) {
    [cache cacheObjects:result];
  }];
}


- (void) signUpWithWorker:(id<SignUpWorker>) signUpWorker
               completion:(SignUpWorkerCompletionBlock) completion {
  [signUpWorker signupWithCompletionBlock:completion];
}


- (void) downloadImageWithQuery:(SASNetworkQuery *)query
                      forWorker:(id<DownloadWorker>)worker
                     completion:(DownloadWorkerImageCompletionBlock)completion {
  [worker downloadImageWithQuery:query completionResult:completion];
}

@end

