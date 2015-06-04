//
//  Device.h
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface Device : NSObject;

@property(strong, nonatomic, readonly, getter=getDeviceNames) NSArray* deviceNames;
@property(strong, nonatomic, readonly, getter=getDeviceImages) NSArray* deviceImages;


@property (nonatomic, strong) NSString *standard_resolution;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *app;
@property (nonatomic) CLLocationCoordinate2D deviceLocation;
@property (nonatomic, strong) NSString *typeOfObject;
@property (nonatomic) int typeOfObjectInt;

-(id) initWithInfoString: (NSString *)infoString;

@end
