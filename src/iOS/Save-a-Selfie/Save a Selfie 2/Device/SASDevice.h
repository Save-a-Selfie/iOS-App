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
typedef NS_ENUM(NSInteger, SASDeviceType) {
    All = 0,
    Defibrillator = 1,
    LifeRing = 2,
    FirstAidKit = 3,
    FireHydrant = 4
};



@interface SASDevice : NSObject;


// @return Device name for specified SASDeviceType.
+ (NSString*) getDeviceNameForDeviceType:(SASDeviceType) deviceType;

// @return Device Image for specified SASDeviceType.
+ (UIImage*) getDeviceImageForDeviceType:(SASDeviceType) deviceType;

// @return Device map annotation image for specified SASDeviceType.
+ (UIImage*) getDeviceMapAnnotationImageForDeviceType:(SASDeviceType) deviceType;

// @return Device map pin image for speified SASDeviceType.
+ (UIImage*) getDeviceMapPinImageForDeviceType:(SASDeviceType) deviceType;


@property (nonatomic, assign, readonly) SASDeviceType type;
@property (nonatomic, strong, readonly) NSString *imageStandardRes;
@property (nonatomic, strong, readonly) NSString *caption;
@property (nonatomic, strong, readonly) NSString *thumb;
@property (nonatomic, strong, readonly) NSString *app;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D deviceLocation;


- (id) initDeviceWithInformationFromString: (NSString *)infoString;

@end
