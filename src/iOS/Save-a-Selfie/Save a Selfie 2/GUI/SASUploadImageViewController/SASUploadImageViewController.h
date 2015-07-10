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



@protocol SASUploadImageViewControllerDelegate <NSObject>

// @Discussion:
//  This method will be called once SASUploadImageViewController is dismissed and remove
//  from its super view. It is possible the user may have clicked `cancel` and decided
//  to cancel the upload. This method will still be called.
//  It is important to note once the user is finished with an SASImageViewController instance
//  this method is called.
- (void)sasUploadImageViewControllerDidFinishUploading:(UIViewController *)viewController withObject:(SASUploadObject *) sasUploadObject;

@end

@interface SASUploadImageViewController : UIViewController

@property(nonatomic, strong) SASUploadObject *sasUploadObject;

@property(nonatomic, weak) id<SASUploadImageViewControllerDelegate> delegate;

@end
