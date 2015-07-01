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

@interface SASUploadImageViewController : UIViewController

@property(nonatomic, strong) SASUploadObject *sasUploadObject;
@property (weak, nonatomic) IBOutlet SASMapView *sasMapView;
@property (weak, nonatomic) IBOutlet UIImageView *blurredImageView;


@end
