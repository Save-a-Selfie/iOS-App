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

@end
