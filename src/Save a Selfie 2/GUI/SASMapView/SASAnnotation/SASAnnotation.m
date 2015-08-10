//
//  SASAnnotation.m
//

#import "SASAnnotation.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"
#import "SASDevice.h"




@implementation SASAnnotation



- (instancetype) initAnnotationWithObject:(SASDevice*) aDevice index:(int) deviceNumber {
    if (self = [super init]) {
        
        _name = [SASDevice getDeviceNameForDeviceType:aDevice.type];
        _coordinate= aDevice.deviceLocation;
        _image = (UIImage*)[SASDevice getDeviceMapAnnotationImageForDeviceType:aDevice.type];
        _device = aDevice;
        _index = deviceNumber;

    }
    return self;
}


@end
