//
//  SASAnnotation.h
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SASDevice.h"

@interface SASAnnotation : NSObject <MKAnnotation>

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
 All SASAnnotations must have a SASDevice property set as
 it is required in the initialisation of an SASAnnotation.
 */
@property (nonatomic, readonly) SASDevice *device;




/**
 Initialises an new SASAnnotation instance.
 
 @param device The device is needed so the correct info
               can be gathered for the annotation i.e coordinates, type etc.
 
 @return New instance of SASAnnotation.
 */
- (instancetype) initAnnotationWithObject:(SASDevice*) device;


@end
