//
//  SASAnnotation.m
//

#import "SASAnnotation.h"
#import "SASDevice.h"


@interface SASAnnotation()

@property(nonatomic, strong) UIImage *image;

@end


@implementation SASAnnotation


- (instancetype) initAnnotationWithObject:(SASDevice*) aDevice {
    if (self = [super init]) {
        
        _name = [SASDevice getDeviceNameForDeviceType:aDevice.type];
        _coordinate = aDevice.deviceLocation;
        _image = (UIImage*)[SASDevice getDeviceMapAnnotationImageForDeviceType:aDevice.type];
        _device = aDevice;
    }
    return self;
}


@end
