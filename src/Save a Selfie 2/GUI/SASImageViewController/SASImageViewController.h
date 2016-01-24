//
//  SASImageViewController.h
//  Save a Selfie
//
//  Created by Stephen Fox on 02/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASAnnotation.h"

@interface SASImageViewController : UIViewController


/**
 This property should be set before presenting
 an instance of this class. It is needed so the
 image, map and description can be set correctly.
 Not setting this property will lead to all the aforementioned 
 not being set.
 */
@property(strong, nonatomic) SASDevice* device;


/**
 Use this flag to change whether or not
 an image will be loadedfrom the url or from the set SASDevice property. 
 The default is YES.

 YES - Image will be downloaded from the server using the devices imageURL property.
 
 NO - Image will not be fetched from the server. This is
      typically assigned when the image is already downloaded
      and is set via the `image` property. If set to NO and
      no `image` property is set no image will be displayed.
 */
@property(assign, nonatomic, getter=shouldDownloadImage) BOOL downloadImage;


/**
 Set this property if the image for the associated device
 has already been downloaded. The BOOL `downloadImage` must be set
 to NO aswell as this property being set for the image to be displayed.
 */
@property(strong, nonatomic) UIImage *image;


@end
