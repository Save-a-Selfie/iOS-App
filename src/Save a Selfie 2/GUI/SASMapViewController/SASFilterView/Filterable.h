//
//  Filterable.h
//  Save a Selfie
//
//  Created by Stephen Fox on 29/09/2015.
//  Copyright © 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SASDevice;


@protocol Filterable <NSObject>

/**
 Filter an array of SASDevices for a SASDeviceType.
 @param devices The devices to filter.
 @param deviceType The device type to apply when filtering.
 @param An array of types SASDevice which have been filtered from the array passed.
 */
- (NSArray<SASAnnotation*>*) filterAnnotations:(NSArray <SASAnnotation*>*)annotations forDeviceType:(SASDeviceType) deviceType;


@end
