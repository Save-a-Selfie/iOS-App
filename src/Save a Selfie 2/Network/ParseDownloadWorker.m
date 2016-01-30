//
//  ParseDownloadWorker.m
//  Save a Selfie
//
//  Created by Stephen Fox on 29/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "ParseDownloadWorker.h"
#import "Selfie.h"
#import <Parse/Parse.h>
#import "SASNetworkQuery.h"

@implementation ParseDownloadWorker

- (void)downloadWithQuery:(SASNetworkQuery *)query completionResult:(DownloadWorkerCompletionBlock) resultBlock {
  switch (query.type) {
    case SASNetworkQueryTypeAll:
      [self downloadAllAndPassToBlock:resultBlock];
      break;
    default:
      break;
  }
}


- (void) downloadAllAndPassToBlock:(DownloadWorkerCompletionBlock) block {
  PFQuery *query = [PFQuery queryWithClassName:@"Selfie"];
  query.limit = 1000;
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    block(objects);
  }];
}
@end
