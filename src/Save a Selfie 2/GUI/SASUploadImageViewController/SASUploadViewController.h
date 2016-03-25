//
//  SASUploadImageViewController.h
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASNetworkObject.h"
#import "SASMapView.h"

typedef NS_ENUM(NSInteger, SASUploadControllerResponse) {
    SASUploadControllerResponseCancelled,
    SASUploadControllerResponseUploaded
};


@protocol SASUploadViewControllerDelegate <NSObject>

/// Called when SASImageViewController is dismissed.
/// An SASUploadControllerResponse is paassed to the delegate.
/// All uploading happens through this UIViewController.
- (void)sasUploadViewController:(UIViewController *)viewController
                   withResponse:(SASUploadControllerResponse) response
                     withObject:(SASNetworkObject *) sasUploadObject;

@end

@interface SASUploadViewController : UIViewController

@property(nonatomic, strong) SASNetworkObject *sasUploadObject;

@property(nonatomic, weak) id<SASUploadViewControllerDelegate> delegate;

@end
