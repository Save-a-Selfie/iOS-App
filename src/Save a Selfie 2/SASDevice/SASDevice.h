//
//  Device.h
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


// Device types:
// Defibrillator
// Life Ring
// First Aid Kit
// Fire Hydrant
// All,
typedef NS_ENUM(int, SASDeviceType) {
    Defibrillator,
    LifeRing,
    FirstAidKit,
    FireHydrant,
    All,
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
@property (nonatomic, strong, readonly) NSString *imageURL;
@property (nonatomic, strong, readonly) NSString *caption;
@property (nonatomic, strong, readonly) NSString *thumb;
@property (nonatomic, strong, readonly) NSString *app;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D deviceLocation;


// Initialises a SASDevice object with device information from a string.
- (id) initDeviceWithInformationFromString: (NSString *)infoString;

@end
