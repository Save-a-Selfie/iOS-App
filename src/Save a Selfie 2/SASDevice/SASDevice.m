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


- (id) initDeviceWithInformationFromString: (NSString *) aInfoString {

	if (self = [super init]) {
        
        _infoString = aInfoString;
        
        NSArray *infoArray = [aInfoString componentsSeparatedByString:@"\t"];
        
        // URL for the image.
        _imageURLString = [infoArray objectAtIndex:0];
        
        _imageURL = [NSURL URLWithString:_imageURLString];
        
        // Caption associated with the device.
        _caption = [infoArray objectAtIndex:1];
        
        // Sets _type with the correct type of device with the `identifier/value`
        // retrieved from the server.
        [self setTypeWithIdentifierFromServer:[[infoArray objectAtIndex:2] intValue]];
        
        // Longitude and Latitude.
        NSNumber *latitude = [infoArray objectAtIndex:3];
		NSNumber *longitude = [infoArray objectAtIndex:4];
		
        _deviceLocation.latitude = latitude.doubleValue;
		_deviceLocation.longitude = longitude.doubleValue;
        
        _thumb = [infoArray objectAtIndex:5];
        _app = [infoArray objectAtIndex:6]; // iPhone app / Instagram / Twitter
	}
    
	return self;
}



- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"\nImageURL: %@,\nCaption: %@ ,\nType %d,\nCoordinates \n{ latititude: %f, \n longtitude: %f \n}\n",
            self.imageURLString,
            self.caption,
            self.type,
            self.deviceLocation.latitude,
            self.deviceLocation.longitude];
    return description;
}



#pragma mark <NSCopying> protocol.
- (id)copyWithZone:(NSZone *)zone {
    SASDevice *copy = [self initDeviceWithInformationFromString:self.infoString];
    return copy;
    
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
