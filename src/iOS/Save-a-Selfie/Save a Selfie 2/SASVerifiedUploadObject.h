//
//  SASVerifiedUploadObject.h
//  Save a Selfie
//
//  Created by Stephen Fox on 09/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SASUploadObject;


@protocol SASVerifiedUploadObject <NSObject>

- (BOOL) captionHasBeenSet;

@end