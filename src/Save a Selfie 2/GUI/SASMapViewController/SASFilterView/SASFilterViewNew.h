//
//  SASFilterViewNew.h
//  Save a Selfie
//
//  Created by Stephen Fox on 27/09/2015.
//  Copyright © 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASMapView.h"

@interface SASFilterViewNew : UIView


/**
 Initialises a new instance a given point.
 */
- (instancetype)initWithPosition:(CGPoint) position forMapView:(SASMapView *) mapView;



/**
 Presents an instance into a view.
 
 @param view The view you want to present the
 */
- (void) presentIntoView:(UIView *) view;





@end
