//
//  DeviceMapViewController.h
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <ImageIO/ImageIO.h>
#import <MapKit/MKAnnotation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <MessageUI/MessageUI.h>

#define METERS_PER_MILE 1609.344

@interface DeviceMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITabBarControllerDelegate>
@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *locateUserButton;
- (IBAction)locateUserMethod:(id)sender;

@end
