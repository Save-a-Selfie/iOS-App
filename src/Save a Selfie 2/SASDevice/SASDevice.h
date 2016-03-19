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
@property (nonnull, nonatomic, strong, readonly) NSString *filePath;
@property (nonnull, nonatomic, strong, readonly) NSString *caption;
@property (nonatomic, readonly) CLLocationCoordinate2D deviceLocation;
@property (nonnull, readonly) NSString *imageURLString;
@property (nonnull, readonly) NSURL *imageURL;


/**
 Creates a SASDevice with all information passed in.
 
 @param type The type e.g. Defibrillator, Life Ring etc.
 @param file The name of the file which resides on the SAS backend.
 @param caption The caption associated with the device.
 @param coordinates The coordinates of the device.
 */
- (nonnull instancetype) initDeviceWithInfo: (SASDeviceType)type
                          filePath:(nonnull NSString*) file
                            caption:(nonnull NSString*) caption
                        coordinates:(CLLocationCoordinate2D) coordinates;




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
+ (nonnull NSString*) getDeviceNameForDeviceType:(SASDeviceType) deviceType;



/**
 Returns the associated device type for each string.
 */
+ (SASDeviceType) deviceTypeForString:(nonnull NSString*) device;

/**
 @return Selected(normal image) device image for given parameter.
 */
+ (nonnull UIImage*) getDeviceImageForDeviceType:(SASDeviceType) deviceType;

/**
 @return Unselected device image for given parameter.
 */
+ (nonnull UIImage *) getUnselectedDeviceImageForDevice:(SASDeviceType) deviceType;


/**
 @return Device map annotation (used for mapView) for given parameter.
 */
+ (nonnull UIImage*) getDeviceMapAnnotationImageForDeviceType:(SASDeviceType) deviceType;



/**
 @return Device map pin for given parameter.
 */
+ (nonnull UIImage*) getDeviceMapPinImageForDeviceType:(SASDeviceType) deviceType;



/**
 Returns string representation of a SASDevice. i.e "Defibrillator" etc.
 */
- (nullable NSString *)deviceName;




@end
