//
//  MyLocation.h
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Device.h"

@interface SASAnnotation : NSObject <MKAnnotation> {
    NSString *_address;
}


@property (copy) NSString *name;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) int index;


- (instancetype) initAnnotationWithDevice:(Device*) device index:(int) deviceNumber;


@end
