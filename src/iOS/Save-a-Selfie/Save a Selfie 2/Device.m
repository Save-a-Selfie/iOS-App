//
//  Device.m
//

#import "Device.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"

@implementation Device
extern NSArray *deviceNames;

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
@end
