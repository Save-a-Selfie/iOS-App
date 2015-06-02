//
//  SASImageViewController.h
//  Save a Selfie
//
//  Created by Stephen Fox on 02/06/2015.
//  Copyright (c) 2015 Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASAnnotation.h"

@interface SASImageViewController : UIViewController


// @Discussion
//  This property should be set before this ViewController
//  is presented, so the correct image can be displayed and
//  appropriate map location.
@property(strong, nonatomic) SASAnnotation* annotation;


@end
