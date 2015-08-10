//
//  SASImageViewController.h
//  Save a Selfie
//
//  Created by Stephen Fox on 02/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASAnnotation.h"

@interface SASImageViewController : UIViewController


/**
 This property should be set before presenting
 an instance of this class. It is needed so the
 image, map and description can be set correctly.
 Not setting this property will lead to all the aforementioned 
 not being set.
 */
@property(strong, nonatomic) SASDevice* device;


@end
