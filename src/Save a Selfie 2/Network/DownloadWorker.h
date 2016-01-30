//
//  DownloadWorker.h
//  Save a Selfie
//
//  Created by Stephen Fox on 29/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASNetworkQuery.h"

@class SASDevice;

@protocol DownloadWorker <NSObject>

typedef void (^DownloadWorkerCompletionBlock)( NSArray <SASDevice *> *result);


- (void) downloadWithQuery:(SASNetworkQuery *) query
          completionResult:(DownloadWorkerCompletionBlock) completionBlock;

@end
