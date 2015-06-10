//
//  SASImagePickerViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
//

#import "SASImagePickerViewController.h"
#import "SASLocation.h"
#import "SASUtilities.h"
#import "SASUploadImage.h"

@interface SASImagePickerViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    CLLocationCoordinate2D currentLocationCoordinates;
}

@property(nonatomic, strong) SASLocation *sasLocation;
@property(nonatomic, strong) SASUploadImage *sasUploadImage;


@end


@implementation SASImagePickerViewController

@synthesize sasLocation;
@synthesize sasUploadImage;
@synthesize sasImagePickerDelegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(sasLocation == nil) {
        self.sasLocation = [[SASLocation alloc] init];
    }
    
    self.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma UIImagePickerControllerDelegate

// @Discussion:
// As of this version 1.1 Save a Selfie does not support
// adding images from camera roll.
// The only support for contributing images is to
// take the image directly.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    

    // @Discussion:
    //  Image taken with camera => no GPS info available, use location SASLocation -currentUserLocation:
    //  Once iOS 8 is widely adopted, would be better to use PHPhotoLibrary to fetch the last image
    //  see: http://stackoverflow.com/questions/
    
    
    if([info objectForKey:UIImagePickerControllerOriginalImage]) {
        
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        self.sasUploadImage = [[SASUploadImage alloc] initWithImage:image];
        
        // Set the timestamp for the image.
        self.sasUploadImage.timeStamp = [SASUtilities getCurrentTimeStamp];
        
        // Get the user's current location.
        currentLocationCoordinates = [sasLocation currentUserLocation];
        
        image = nil;
    }
    
    
    
#pragma TODO: Get this WORKING!!
   
    
    // Send the image to delegate.
    if(self.sasImagePickerDelegate != nil) {
        [self.sasImagePickerDelegate sasImagePickerController:self didFinishWithImage:self.sasUploadImage];
    }
}



- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self removeFromParentViewController];
    self.sasLocation = nil;
}

@end
