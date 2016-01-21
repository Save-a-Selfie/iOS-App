//
//  SASFilterView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 21/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"
#import "Filterable.h"
#import "SASMapView.h"

@class SASFilterView;



@interface SASFilterView : UIView


/**
 Animate SASFilterView into another view.
 */
- (void) animateIntoView:(UIView*) view;


/**
 An instance of MKMapView that implemented the Filterable protocol
 see Filterable.h for more info.
 The map view will be message about what annotations to
 filter.
 */
- (void) mapToFilter:(MKMapView<Filterable>*) mapView;

@end