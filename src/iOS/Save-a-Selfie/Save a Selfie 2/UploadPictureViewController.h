//
//  UploadPictureViewController.h
//  Save-a-Selfie
//
//  Created by Nadja Deininger on 12/05/14.
//  Copyright (c) 2014 Code for All Ireland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <MapKit/MapKit.h>

@interface UploadPictureViewController : UIViewController
<UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
CLLocationManagerDelegate,
UITabBarControllerDelegate,
UITextFieldDelegate>

@end
