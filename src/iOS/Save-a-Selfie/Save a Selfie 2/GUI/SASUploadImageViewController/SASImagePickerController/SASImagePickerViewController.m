//
//  SASImagePickerViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
//

#import "SASImagePickerViewController.h"

#import "SASUtilities.h"


@interface SASImagePickerViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong) UIImage* imageTakenFromCamera;


@end


@implementation SASImagePickerViewController

@synthesize imageTakenFromCamera;
@synthesize sasImagePickerDelegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
}




#pragma UIImagePickerControllerDelegate

// @Discussion:
// As of this version 1.1 Save a Selfie does not support
// adding images from camera roll.
// The only support for contributing images is to
// take the image directly.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    

    if([info objectForKey:UIImagePickerControllerOriginalImage]) {
        self.imageTakenFromCamera = info[UIImagePickerControllerOriginalImage];
    }
    
    
    // Send the image to delegate.
    if(self.sasImagePickerDelegate != nil && [self.sasImagePickerDelegate respondsToSelector:@selector(sasImagePickerController:didFinishWithImage:)]) {
        
        [self.sasImagePickerDelegate sasImagePickerController:self
                                           didFinishWithImage:self.imageTakenFromCamera];
    }
}



- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
