//
//  SASUploadImageViewController.h
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASUploadObject.h"
#import "SASMapView.h"

typedef NS_ENUM(NSInteger, SASUploadControllerResponse) {
    SASUploadControllerResponseUploaded,
    SASUploadControllerResponseCancelled
};


@protocol SASUploadImageViewControllerDelegate <NSObject>

/// Called when SASImageViewController is dismissed.
/// An SASUploadControllerResponse is paassed to the delegate.
- (void)sasUploadImageViewControllerDidFinishUploading:(UIViewController *)viewController
                                          withResponse:(SASUploadControllerResponse) response
                                            withObject:(SASUploadObject *) sasUploadObject;

@end

@interface SASUploadImageViewController : UIViewController

@property(nonatomic, strong) SASUploadObject *sasUploadObject;

@property(nonatomic, weak) id<SASUploadImageViewControllerDelegate> delegate;

@end
