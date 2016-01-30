//
//  SASImagePickerViewController.h
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SASNetworkObject;
@class SASImagePickerViewController;

@protocol SASImagePickerDelegate <NSObject>

// Called when the user has taken an image with their device.
// Currently Save A Selfie only supports images taken with the camera.
- (void) sasImagePickerController:(SASImagePickerViewController*) sasImagePicker didFinishWithImage:(UIImage*) image;

@optional
// Called when the user pressed the cancel button.
- (void) sasImagePickerControllerDidCancel:(SASImagePickerViewController *) sasImagePickerController;

// Due to the way this app presents it's view for uploading an image
// we need to know when sasImagePicker has been removed from the view hierarchy.
- (void) sasImagePickerControllerDidDissapear:(SASImagePickerViewController *) sasImagePicker;

@end


@interface SASImagePickerViewController : UIImagePickerController

@property(nonatomic, weak) id<SASImagePickerDelegate> sasImagePickerDelegate;

@end
