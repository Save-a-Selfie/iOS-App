//
//  SASAnnotation.h
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SASDevice.h"

@interface SASAnnotation : NSObject <MKAnnotation> {
    NSString *_address;
}


@property (copy) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) SASDevice *device;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) int index;


- (instancetype) initAnnotationWithObject:(SASDevice*) device index:(int) deviceNumber;


@end
