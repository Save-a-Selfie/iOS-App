//
//  Device.m
//

#import "Device.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"

@implementation Device



@synthesize deviceNames;
@synthesize deviceImages;

// Device types:
// 0 - Defibrillator
// 1 - Life Ring
// 2 - First Aid Kit
// 3 - Fire Hydrant


-(id) initWithInfoString: (NSString *)infoString {
	self = [super init];
	if (self) {
		NSArray *info = [infoString componentsSeparatedByString:@"\t"];
		
        _standard_resolution = [info objectAtIndex:0];
        _caption = [info objectAtIndex:1];
        _typeOfObjectInt = [[info objectAtIndex:2] intValue];
        _typeOfObject = deviceNames[_typeOfObjectInt];
		
        NSNumber *latitude = [info objectAtIndex:3];
		NSNumber *longitude = [info objectAtIndex:4];
		
        _deviceLocation.latitude = latitude.doubleValue;
		_deviceLocation.longitude = longitude.doubleValue;
        
        _thumb = [info objectAtIndex:5];
        _app = [info objectAtIndex:6]; // iPhone app / Instagram / Twitter
        
        plog(@"_standard_resolution: %@", _standard_resolution);
	}
    
	return self;
}


- (NSArray *)getDeviceNames {
    return deviceNames = [[NSArray alloc] initWithObjects:
                          @"Defibrillator",
                          @"Life Ring",
                          @"First Aid Kit",
                          @"Fire Hydrant",
                          nil];
}


- (NSArray *)getDeviceImages {
    return deviceImages = @[[UIImage imageNamed:@"Defibrillator"],
                            [UIImage imageNamed:@"LifeRing"],
                            [UIImage imageNamed:@"FirstAidKit"],
                            [UIImage imageNamed:@"FireHydrant"]
                            ];
}

@end
