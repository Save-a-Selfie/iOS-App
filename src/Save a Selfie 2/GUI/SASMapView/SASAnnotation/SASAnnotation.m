//
//  SASAnnotation.m
//

#import "SASAnnotation.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"
#import "SASDevice.h"




@implementation SASAnnotation

@synthesize name;
@synthesize coordinate;
@synthesize image;
@synthesize device;
@synthesize index;

- (instancetype) initAnnotationWithDevice:(SASDevice*) aDevice index:(int) deviceNumber {
    if (self = [super init]) {
        
        self.name = [SASDevice getDeviceNameForDeviceType:aDevice.type];
        self.coordinate= aDevice.deviceLocation;
        self.image = (UIImage*)[SASDevice getDeviceMapAnnotationImageForDeviceType:aDevice.type];
        self.device = aDevice;
        self.index = deviceNumber;

    }
    return self;
}


@end
