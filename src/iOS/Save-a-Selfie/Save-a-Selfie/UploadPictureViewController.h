//
//  UploadPictureViewController.h
//  Save-a-Selfie
//
//  Created by Nadja Deininger on 12/05/14.
//  Copyright (c) 2014 Code for All Ireland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface UploadPictureViewController : UIViewController
<UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate>

@property BOOL newMedia;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property UIImagePickerController *picker;
- (IBAction)useCamera;
- (IBAction)useCameraRoll;
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
@end
