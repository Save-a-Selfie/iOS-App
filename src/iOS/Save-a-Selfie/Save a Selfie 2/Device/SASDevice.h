//
//  Device.h
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


// Device types:
// 0 - Defibrillator
// 1 - Life Ring
// 2 - First Aid Kit
// 3 - Fire Hydrant
// 4 - All - All annotations
typedef enum : NSUInteger {
    Defibrillator,
    LifeRing,
    FirstAidKit,
    FireHydrant,
    All,
    numberOfDevices = 5
} DeviceType;


@interface SASDevice : NSObject;

// Returns NSArray all the device names as a NSString.
+ (NSArray*) deviceNames;
// Returns NSArray of UIImages for the devices, respectively.
+ (NSArray*) deviceImages;
// Returns NSArray of UIImages for the devices as pins for a map.
+ (NSArray*) deviceMapPinImages;

+ (NSArray*) deviceAnnotationImages;


@property (nonatomic, assign) DeviceType type;
@property (nonatomic, strong) NSString *imageStandardRes;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *app;
@property (nonatomic) CLLocationCoordinate2D deviceLocation;


- (id) initDeviceWithInformationFromString: (NSString *)infoString;

@end
