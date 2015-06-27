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



+ (NSArray *)deviceNames {
    return [NSArray arrayWithObjects:
            @"Defibrillator",
            @"Life Ring",
            @"First Aid Kit",
            @"Fire Hydrant",
            @"All",
            nil];
}

// TODO: These array objects should be moved.
+ (NSArray *)deviceImages {
    
    return [NSArray arrayWithObjects:
            [UIImage imageNamed:@"Defibrillator"],
            [UIImage imageNamed:@"LifeRing"],
            [UIImage imageNamed:@"FirstAidKit"],
            [UIImage imageNamed:@"FireHydrant"],
            [UIImage imageNamed:@"FireHydrant"],
            nil];
}


+ (NSArray *) deviceAnnotationImages {
    return [NSArray arrayWithObjects:
            [UIImage imageNamed:@"AEDAnnotation"],
            [UIImage imageNamed:@"LifeRingAnnotation"],
            [UIImage imageNamed:@"FAKitAnnotation"],
            [UIImage imageNamed:@"FireHydrantAnnotation"],
            [UIImage imageNamed:@"FireHydrantAnnotation"],
            nil];
}

+ (NSArray*) deviceMapPinImages {
    
    return [NSArray arrayWithObjects:
            [UIImage imageNamed:@"MapPinAED"],
            [UIImage imageNamed:@"MapPinLifeRing"],
            [UIImage imageNamed:@"MapPinFAKit"],
            [UIImage imageNamed:@"MapPinFireHydrant"],
            nil];
}

@end
