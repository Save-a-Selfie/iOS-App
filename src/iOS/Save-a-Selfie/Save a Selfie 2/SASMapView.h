//
//  SASMapView.h
//  SASMapView
//
//  Created by Stephen Fox on 25/05/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASLocation.h"

#define METERS_PER_MILE 1609.344


@interface SASMapView : UIView <SASLocationDelegate>

-(void) locateUser;

@end
