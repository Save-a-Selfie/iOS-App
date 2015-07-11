//
//  UploadPictureViewController.h
//  Save-a-Selfie
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

@interface UploadPictureViewController : UIViewController
<UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
CLLocationManagerDelegate,
UITabBarControllerDelegate,
UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;
@property (weak, nonatomic) IBOutlet UITextView *commentField;
@property (strong, nonatomic) IBOutlet UIButton *backArrow;
@property (strong, nonatomic) IBOutlet UIButton *OKButton;
@property (strong, nonatomic) IBOutlet UIButton *SASLogoButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UILabel *whiteBackground;
@property (weak, nonatomic) IBOutlet UILabel *multipurposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *multilabelBackground;
@property (weak, nonatomic) IBOutlet UILabel *typeInfoHere;
@property (weak, nonatomic) IBOutlet UIImageView *littleGuy;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISwitch *sendToFBButton;
@property (weak, nonatomic) IBOutlet UILabel *sendToFBLabel;
- (IBAction)backArrowAction:(id)sender;
- (IBAction)sendToFBAction:(id)sender;
- (IBAction)OKAction:(id)sender;
- (IBAction)useCamera;
- (IBAction)useCameraRoll;
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (IBAction)sendIt:(id)sender;
- (void) sendImageToServer;

@end
