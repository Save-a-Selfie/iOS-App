//
//  Filterable.h
//  Save a Selfie
//
//  Created by Stephen Fox on 29/09/2015.
//  Copyright © 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASAnnotation.h"

/**
 A protocol for any MKMapView instance can implement
 to filter all the devices on the map.
 */
@protocol MapFilterable <NSObject>

- (void) filterMapForDevice:(SASDeviceType) deviceType;


@end
