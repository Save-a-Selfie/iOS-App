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
        
        // Sets _type with the correct type of device with the `identifier/value`
        // retrieved from the server.
        [self setTypeWithIdentifierFromServer:[[info objectAtIndex:2] intValue]];
        
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



// @Disscussion:
//  Currently when retrieved from the server each SASDevice.type has a corresponding
//  value:
//      - Defibrillator: 0
//      - LifeRing: 1
//      - FirstAidKit: 2
//      - FireHyrdant: 3
// This value will translate into a SASDeviceType, which is recognised across the app.
// this method sets the SASDeviceType for SASDevice.type with the `identifier/ value` retrieved from the server.
- (void) setTypeWithIdentifierFromServer:(int) indentifier {
    switch (indentifier) {
        case 0:
            _type = Defibrillator;
            break;
            
        case 1:
            _type = LifeRing;
            break;
            
        case 2:
            _type = FirstAidKit;
            break;
            
        case 3:
            _type = FireHydrant;
            break;
            
        default:
            break;
    }
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
            
        case LifeRing:
            return @"Life Ring";
            
        case FirstAidKit:
            return @"First Aid Kit";
            
        case FireHydrant:
            return @"Fire Hydrant";
            
        case All:
            return @"All";
            
        default:
            break;
    }
}

+ (UIImage*) getDeviceImageForDeviceType:(SASDeviceType) deviceType {
    
    if(deviceType == Defibrillator) {
        return [UIImage imageNamed:@"Defibrillator"];
    } else if (deviceType == LifeRing) {
        return [UIImage imageNamed:@"Defibrillator"];
    } else if (deviceType == FirstAidKit) {
        return [UIImage imageNamed:@"Defibrillator"];
    } else if (deviceType == FireHydrant) {
        return [UIImage imageNamed:@"Defibrillator"];
    } else {
        return [[UIImage alloc] init];
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
