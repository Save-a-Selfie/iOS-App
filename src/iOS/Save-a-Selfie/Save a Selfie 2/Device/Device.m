//
//  Device.m
//

#import "Device.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"

@implementation Device



- (id) initDeviceWithInformationFromString: (NSString *)infoString {

	if (self = [super init]) {
        
		NSArray *info = [infoString componentsSeparatedByString:@"\t"];
		
        // URL for the image.
        _imageStandardRes = [info objectAtIndex:0];
        
        // Caption associated with the device.
        _caption = [info objectAtIndex:1];
        
        // Type of device. The int value will translate to
        // a enum called DeviceType.
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



+ (NSArray *)deviceNames {
    return [NSArray arrayWithObjects:
            @"Defibrillator",
            @"Life Ring",
            @"First Aid Kit",
            @"Fire Hydrant",
            nil];
}


+ (NSArray *)deviceImages {
    
    return [NSArray arrayWithObjects:
            [UIImage imageNamed:@"Defibrillator"],
            [UIImage imageNamed:@"LifeRing"],
            [UIImage imageNamed:@"FirstAidKit"],
            [UIImage imageNamed:@"FireHydrant"],
            nil];
}


+ (NSArray*) deviceMapPins {
    
    return [NSArray arrayWithObjects:
            [UIImage imageNamed:@"DefibrillatorMapPin"],
            [UIImage imageNamed:@"LifeRingMapPin"],
            [UIImage imageNamed:@"FirstAidKitMapPin"],
            [UIImage imageNamed:@"FireHydrantMapPin"],
            nil];
}

@end
