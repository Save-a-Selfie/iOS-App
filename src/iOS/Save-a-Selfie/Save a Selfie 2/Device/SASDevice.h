//
//  Device.h
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


// Device types:
// 0 - Defibrillator
// 1 - Life Ring
// 2 - First Aid Kit
// 3 - Fire Hydrant
// 4 - All - All Devices
typedef enum : NSUInteger {
    All,
    Defibrillator,
    LifeRing,
    FirstAidKit,
    FireHydrant,
}SASDeviceType;



@interface SASDevice : NSObject;


// @return Device name for specified SASDeviceType.
+ (NSString*) getDeviceNameForDeviceType:(SASDeviceType) deviceType;

// @return Device Image for specified SASDeviceType.
+ (UIImage*) getDeviceImageForDeviceType:(SASDeviceType) deviceType;

// @return Device map annotation image for specified SASDeviceType.
+ (UIImage*) getDeviceMapAnnotationImageForDeviceType:(SASDeviceType) deviceType;

// @return Device map pin image for speified SASDeviceType.
+ (UIImage*) getDeviceMapPinImageForDeviceType:(SASDeviceType) deviceType;


@property (nonatomic, assign) SASDeviceType type;
@property (nonatomic, strong) NSString *imageStandardRes;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *app;
@property (nonatomic) CLLocationCoordinate2D deviceLocation;


- (id) initDeviceWithInformationFromString: (NSString *)infoString;

@end
