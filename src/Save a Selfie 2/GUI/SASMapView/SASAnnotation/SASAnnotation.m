//
//  SASAnnotation.m
//

#import "SASAnnotation.h"



@interface SASAnnotation()

@property(nonatomic, strong) UIImage *image;

@end


@implementation SASAnnotation

+ (SASAnnotation*) annotationWithSASDevice:(SASDevice *) device {
  if (!device) {
    return  nil;
  }
  SASAnnotation *annotation = [[SASAnnotation alloc] init];
  annotation.name = [SASDevice getDeviceNameForDeviceType:device.type];
  annotation.deviceType = device.type;
  annotation.coordinate = device.deviceLocation;
  annotation.image = (UIImage*)[SASDevice getDeviceMapAnnotationImageForDeviceType:device.type];
  annotation.device = device;
  return annotation;
}


#pragma mark <NSCopying> protocol
- (id)copyWithZone:(NSZone *)zone {
  SASAnnotation *copy = [[SASAnnotation alloc] init];
  copy.name = self.name;
  copy.deviceType = self.deviceType;
  copy.coordinate = self.coordinate;
  copy.image = [self.image copy];
  return copy;
}


@end
