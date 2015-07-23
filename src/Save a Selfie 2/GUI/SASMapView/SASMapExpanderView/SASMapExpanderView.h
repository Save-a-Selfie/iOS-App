//
//  SASMapExpanderView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 23/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASMapView.h"


@interface SASMapExpanderView : UIView

/** This button is used to bring the user back to whatever
    region on the map the pin is located for the map.
*/
@property (nonatomic, copy) UIButton *mapPinButton;



- (instancetype) initWithMap:(SASMapView *) mapView;


- (void) animateIntoView:(UIView *) view;

@end
