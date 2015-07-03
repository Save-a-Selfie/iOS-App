//
//  Device.h
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


// Device types:
// All - All Devices
// Defibrillator
// Life Ring
// First Aid Kit
// Fire Hydrant
typedef NS_ENUM(int, SASDeviceType) {
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


@property (nonatomic, assign) SASDeviceType type;
@property (nonatomic, strong, readonly) NSString *imageStandardRes;
@property (nonatomic, strong, readonly) NSString *caption;
@property (nonatomic, strong, readonly) NSString *thumb;
@property (nonatomic, strong, readonly) NSString *app;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D deviceLocation;


- (id) initDeviceWithInformationFromString: (NSString *)infoString;

@end
