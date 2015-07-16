//
//  SASUploadImage.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploadObject.h"
#import "UIImage+SASImage.h"

@implementation SASUploadObject

@synthesize timeStamp;
@synthesize associatedDevice = _associatedDevice;
@synthesize coordinates;
@synthesize image = _image;
@synthesize caption;
@synthesize identifier;
@synthesize UUID;

- (instancetype)initWithImage:(UIImage *)imageToUpload {
    
    if (self = [super init]) {
        // @Discussion:
        // See UIImage+SASNormalizeImage.h
        // for reason on why we need to normalize
        // the image property.
        _image = [imageToUpload normalizedImage];
        
        _associatedDevice = [[SASDevice alloc] init];
    }
    return self;
}





#pragma mark SASVerifiedUploadObject Protocol
- (BOOL)captionHasBeenSet {
    
    NSLog(@"%@", self.caption);
    if ([self.caption isEqualToString:@""] ||
        [self.caption isEqualToString:@"Add Location Information"] ||
        self.caption == nil) {
        
        return NO;
        
    } else {
        return YES;
    }
}



@end
