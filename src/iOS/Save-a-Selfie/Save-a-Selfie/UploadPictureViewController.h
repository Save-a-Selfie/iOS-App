//
//  UploadPictureViewController.h
//  Save-a-Selfie
//
//  Created by Nadja Deininger on 12/05/14.
//  Copyright (c) 2014 Code for All Ireland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import  <CoreLocation/CoreLocation.h>


@interface UploadPictureViewController : UIViewController
<UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property BOOL newMedia;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property UIImagePickerController *picker;
@property (readonly) CLLocationManager *locationManager;
@property (readonly) CLLocationCoordinate2D currentLocation;
- (IBAction)useCamera;
- (IBAction)useCameraRoll;
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void) addLocationDataToImage;
- (void) sendImageToServer:(UIImage *) image;
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation;

- (UIImage *) createThumbnail: (UIImage *) orig;
@end
