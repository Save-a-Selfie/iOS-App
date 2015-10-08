//
//  SASFilterViewNew.h
//  Save a Selfie
//
//  Created by Stephen Fox on 27/09/2015.
//  Copyright © 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASMapView.h"
#import "SASDevice.h"
#import "Filterable.h"

@class SASMapView;

/**
 A popup view which allows the user to filter
 the mapView according to a device.
 */
@interface SASFilterViewNew : UIView


/**
 Initialises a new instance a given point.
 */
- (instancetype)initWithPosition:(CGPoint) position forMapView:(SASMapView <Filterable> *) mapView;



/**
 Presents an instance into a view.
 
 @param view The view you want to present the
 */
- (void) presentIntoView:(UIView *) view;



/**
 Flag to determine if the filter view is currently
 in the view hierarchy.
 */
@property (readonly) BOOL isInViewHierachy;


@end
