//
//  Device.m
//

#import "SASDevice.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"


@implementation SASDevice


- (id) initDeviceWithInformationFromString: (NSString *)infoString {

	if (self = [super init]) {
        
        
		NSArray *info = [infoString componentsSeparatedByString:@"\t"];
        
        // URL for the image.
        _imageStandardRes = [info objectAtIndex:0];
        
        // Caption associated with the device.
        _caption = [info objectAtIndex:1];
        
        // Type of device. The int value will translate to
        // a enum of type DeviceType.
        _type = [[info objectAtIndex:2] intValue];
		
        
        // Longitude and Latitude.
        NSNumber *latitude = [info objectAtIndex:3];
		NSNumber *longitude = [info objectAtIndex:4];
		
        _deviceLocation.latitude = latitude.doubleValue;
		_deviceLocation.longitude = longitude.doubleValue;
        
        
        _thumb = [info objectAtIndex:5];
        _app = [info objectAtIndex:6]; // iPhone app / Instagram / Twitter
	}
    
	return self;
}



// @Discussion:
//  Currently this is quite a verbose way of returning the correct object
//  for the SASDeviceType, however it is more safe than just returning an array of objects.
//  Ideally an NSDictionary with key/value pair would be ideal for this and would make this slightly
//  cleaner. However, as DeviceType is a NS_ENUM we cannot used it as a key in an NSDictionary as
//  key/values must be objects(id).
//
// TODO: Provide an object wrapper for SASDeviceType so we can use NSDictionary for key/value pairs.
//

+ (NSString*) getDeviceNameForDeviceType:(SASDeviceType) deviceType {
    switch (deviceType) {
        case Defibrillator:
            return @"Defibrillator";
            break;
            
        case LifeRing:
            return @"Life Ring";
            break;
            
        case FirstAidKit:
            return @"First Aid Kit";
            break;
            
        case FireHydrant:
            return @"Fire Hydrant";
            break;
            
        case All:
            return @"All";
            break;
            
        default:
            break;
    }
}

+ (UIImage*) getDeviceImageForDeviceType:(SASDeviceType) deviceType {
    switch (deviceType) {
            
        case Defibrillator:
            return [UIImage imageNamed:@"Defibrillator"];
            break;
            
        case LifeRing:
            return [UIImage imageNamed:@"LifeRing"];
            break;
            
        case FirstAidKit:
            return [UIImage imageNamed:@"FirstAidKit"];
            break;
            
            
        case FireHydrant:
            return [UIImage imageNamed:@"FireHydrant"];
            break;
            
        case All:
            return [[UIImage alloc] init];
            
        default:
            break;
    }
}


+ (UIImage*) getDeviceMapAnnotationImageForDeviceType:(SASDeviceType) deviceType {
    
    switch (deviceType) {
        case Defibrillator:
            return [UIImage imageNamed:@"AEDAnnotation"];
            break;
            
        case LifeRing:
            return [UIImage imageNamed:@"LifeRingAnnotation"];
            break;
            
        case FirstAidKit:
            return [UIImage imageNamed:@"FAKitAnnotation"];
            break;
            
        case FireHydrant:
            return [UIImage imageNamed:@"FireHydrantAnnotation"];
            break;
            
        case All:
            return [[UIImage alloc] init];
            
        default:
            break;
    }
}


+ (UIImage*) getDeviceMapPinImageForDeviceType:(SASDeviceType) deviceType {
    
    switch (deviceType) {
        case Defibrillator:
            return [UIImage imageNamed:@"MapPinAED"];
            break;
            
        case LifeRing:
            return [UIImage imageNamed:@"MapPinLifeRing"];
            break;
            
        case FirstAidKit:
            return [UIImage imageNamed:@"MapPinFAKit"];
            break;
            
        case FireHydrant:
            return [UIImage imageNamed:@"MapPinFireHydrant"];
            break;
            
        case All:
            return [[UIImage alloc] init];
            break;
            
        default:
            break;
    }
}

@end
