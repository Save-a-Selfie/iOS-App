//
//  SASAnnotation.h
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SASDevice.h"

@interface SASAnnotation : NSObject <MKAnnotation, NSCopying>

/**
 This property can be used to indentify what type
 of SASDevice an instance holds i.e Defibrillator, Life Ring etc..
 */
@property (copy) NSString *name;

/**
 The coordinates of the annotation.
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


/**
 This property is set when a SASAnnotation has been initialised
 which a SASDevice.
 */
@property (nonatomic, assign) SASDeviceType deviceType;

/**
 Initialises an new SASAnnotation instance given a SASDevice.
 
 @param device The device is needed so the correct info
               can be gathered for the annotation i.e coordinates, type etc.
 
 @return New instance of SASAnnotation.
 */
+ (SASAnnotation*) annotationWithSASDevice:(SASDevice*) device;



@end
