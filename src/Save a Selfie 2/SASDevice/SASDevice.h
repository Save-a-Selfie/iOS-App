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
    SASDeviceTypeDefibrillator,
    SASDeviceTypeLifeRing,
    SASDeviceTypeFirstAidKit,
    SASDeviceTypeFireHydrant,
    SASDeviceTypeAll,
};



@interface SASDevice : NSObject <NSCopying>;

@property (nonatomic, assign) SASDeviceType type;
@property (nonatomic, strong, readonly) NSString *imageURLString;
@property (nonatomic, strong, readonly) NSURL *imageURL;
@property (nonatomic, strong, readonly) NSString *caption;
@property (nonatomic, readonly) CLLocationCoordinate2D deviceLocation;



/**
 Returns an SASDevice instance that has been initiliased with a string.
 
 @param infoString
 A string containing all the information to create a SASDevice object.
 The information string is typically gotten from the server and has
 all the neccessary information to create the instance.
 
 @return SASDevice
 */
- (instancetype) initDeviceWithInformationFromString: (NSString *)infoString;


/**
 Returns a name for a device type.
 Possible device names returned from this function are:
        - Defibrillator
        - Life Ring
        - First Aid Kit
        - Fire Hydrant
        - All
 Note All is used in special cases throughout the app.
 */
+ (NSString*) getDeviceNameForDeviceType:(SASDeviceType) deviceType;



/**
 @return Selected(normal image) device image for given parameter.
 */
+ (UIImage*) getDeviceImageForDeviceType:(SASDeviceType) deviceType;

/**
 @return Unselected device image for given parameter.
 */
+ (UIImage *) getUnselectedDeviceImageForDevice:(SASDeviceType) deviceType;


/**
 @return Device map annotation (used for mapView) for given parameter.
 */
+ (UIImage*) getDeviceMapAnnotationImageForDeviceType:(SASDeviceType) deviceType;



/**
 @return Device map pin for given parameter.
 */
+ (UIImage*) getDeviceMapPinImageForDeviceType:(SASDeviceType) deviceType;








/**
 Returns string representation of a SASDevice. i.e "Defibrillator" etc.
 */
- (NSString *)deviceName;


@end
