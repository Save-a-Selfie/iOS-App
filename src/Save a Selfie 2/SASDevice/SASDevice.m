//
//  Device.m
//

#import "SASDevice.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"


@implementation SASDevice

@synthesize type;


- (id) initDeviceWithInformationFromString: (NSString *)infoString {

	if (self = [super init]) {
        
        NSArray *info = [infoString componentsSeparatedByString:@"\t"];
        
        // URL for the image.
        _imageURL = [info objectAtIndex:0];
        
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
// This method sets the SASDeviceType for SASDevice.type with the `identifier/ value` retrieved from the server.
- (void) setTypeWithIdentifierFromServer:(int) indentifier {
    switch (indentifier) {
        case 0:
            self.type = Defibrillator;
            break;
            
        case 1:
            self.type = LifeRing;
            break;
            
        case 2:
            self.type = FirstAidKit;
            break;
            
        case 3:
            self.type = FireHydrant;
            break;
            
        default:
            break;
    }
}


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
            return [UIImage new];
            
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
