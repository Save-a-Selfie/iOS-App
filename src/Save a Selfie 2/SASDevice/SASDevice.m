//
//  Device.m
//

#import "SASDevice.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"

@interface SASDevice()

@property(strong, nonatomic) NSString *infoString;

@end

@implementation SASDevice



- (nonnull instancetype) initDeviceWithInfo: (SASDeviceType)type
                                   filePath:(nonnull NSString*) file
                                    caption:(nonnull NSString*) caption
                                coordinates:(CLLocationCoordinate2D) coordinates {
  _type = type;
  _filePath = file;
  _caption = caption;
  _deviceLocation = coordinates;
  return self;
}


- (NSString *)description {
  NSString *description = [NSString stringWithFormat:@"\aaeronnImageFile: %@,\nCaption: %@ ,\nType %d,\nCoordinates \n{ latititude: %f, \n longtitude: %f \n}\n",
                           self.filePath,
                           self.caption,
                           self.type,
                           self.deviceLocation.latitude,
                           self.deviceLocation.longitude];
  return description;
}


- (id)copyWithZone:(NSZone *)zone {
  return [[SASDevice alloc] initDeviceWithInfo:self.type
                                     filePath:[self.filePath copy]
                                       caption:[self.caption copy]
                                   coordinates:self.deviceLocation];
}

+ (SASDeviceType)deviceTypeForString:(nonnull NSString *)device {
  
  if ([[device lowercaseString] containsString:@"defib"]) {
    return SASDeviceTypeDefibrillator;
  } else if ([[device lowercaseString] containsString:@"life"]) {
    return SASDeviceTypeLifeRing;
  } else if ([[device lowercaseString] containsString:@"first"]) {
    return SASDeviceTypeFirstAidKit;
  } else if ([[device lowercaseString] containsString:@"fire"]) {
    return SASDeviceTypeFireHydrant;
  } else {
    return -1;
  }
}

- (NSString*) deviceName {
  return [SASDevice getDeviceNameForDeviceType:self.type];
}




// @Disscussion:
//  Currently when retrieved from the server each SASDevice.type has a corresponding
//  value:
//      - Defibrillator: 0
//      - LifeRing: 1
//      - FirstAidKit: 2
//      - FireHyrdant: 3
// This value will translate into a SASDeviceType, which is recognised across the app.
// This method sets the SASDeviceType for SASDevice.type with the `identifier/ value` retrieved from the server.
- (void) setTypeWithIdentifierFromServer:(int) indentifier {
  switch (indentifier) {
    case 0:
      self.type = SASDeviceTypeDefibrillator;
      break;
      
    case 1:
      self.type = SASDeviceTypeLifeRing;
      break;
      
    case 2:
      self.type = SASDeviceTypeFirstAidKit;
      break;
      
    case 3:
      self.type = SASDeviceTypeFireHydrant;
      break;
      
    default:
      break;
  }
}


+ (NSString*) getDeviceNameForDeviceType:(SASDeviceType) deviceType {
  
  switch (deviceType) {
    case SASDeviceTypeDefibrillator:
      return @"Defibrillator";
      
    case SASDeviceTypeLifeRing:
      return @"Life Ring";
      
    case SASDeviceTypeFirstAidKit:
      return @"First Aid Kit";
      
    case SASDeviceTypeFireHydrant:
      return @"Fire Hydrant";
      
    case SASDeviceTypeAll:
      return @"All";
      
    default:
      break;
  }
}



+ (UIImage*) getDeviceImageForDeviceType:(SASDeviceType) deviceType {
  
  switch (deviceType) {
    case SASDeviceTypeDefibrillator:
      return [UIImage imageNamed:@"Defibrillator"];
      break;
      
    case SASDeviceTypeLifeRing:
      return [UIImage imageNamed:@"LifeRing"];
      break;
      
    case SASDeviceTypeFirstAidKit:
      return [UIImage imageNamed:@"FirstAidKit"];
      break;
      
    case SASDeviceTypeFireHydrant:
      return [UIImage imageNamed:@"FireHydrant"];
      break;
      
    case SASDeviceTypeAll:
      return [UIImage new];
      
    default:
      break;
  }
}



+ (UIImage *) getUnselectedDeviceImageForDevice:(SASDeviceType) deviceType {
  
  switch (deviceType) {
    case SASDeviceTypeDefibrillator:
      return [UIImage imageNamed:@"DefibrillatorUnselected"];
      
      
    case SASDeviceTypeLifeRing:
      return [UIImage imageNamed:@"LifeRingUnselected"];
      
    case SASDeviceTypeFirstAidKit:
      return [UIImage imageNamed:@"FirstAidKitUnselected"];
      
      
    case SASDeviceTypeFireHydrant:
      return [UIImage imageNamed:@"FireHydrantUnselected"];
      
    case SASDeviceTypeAll:
      return [UIImage new];
      
    default:
      break;
  }
}


+ (UIImage*) getDeviceMapAnnotationImageForDeviceType:(SASDeviceType) deviceType {
  
  switch (deviceType) {
    case SASDeviceTypeDefibrillator:
      return [UIImage imageNamed:@"AEDAnnotation"];
      break;
      
    case SASDeviceTypeLifeRing:
      return [UIImage imageNamed:@"LifeRingAnnotation"];
      break;
      
    case SASDeviceTypeFirstAidKit:
      return [UIImage imageNamed:@"FAKitAnnotation"];
      break;
      
    case SASDeviceTypeFireHydrant:
      return [UIImage imageNamed:@"FireHydrantAnnotation"];
      break;
      
    case SASDeviceTypeAll:
      return [[UIImage alloc] init];
      
    default:
      break;
  }
}


+ (UIImage*) getDeviceMapPinImageForDeviceType:(SASDeviceType) deviceType {
  switch (deviceType) {
    case SASDeviceTypeDefibrillator:
      return [UIImage imageNamed:@"MapPinAED"];
      break;
      
    case SASDeviceTypeLifeRing:
      return [UIImage imageNamed:@"MapPinLifeRing"];
      break;
      
    case SASDeviceTypeFirstAidKit:
      return [UIImage imageNamed:@"MapPinFAKit"];
      break;
      
    case SASDeviceTypeFireHydrant:
      return [UIImage imageNamed:@"MapPinFireHydrant"];
      break;
      
    case SASDeviceTypeAll:
      return [[UIImage alloc] init];
      break;
      
    default:
      break;
  }
}


@end
