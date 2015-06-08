//
//  SASSocial.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASSocial.h"
#import <Social/Social.h>

@implementation SASSocial



+ (void) shareToSocialMedia:(NSString*)textToShare andImage:(UIImage*)image target:(id) target {
    
    // Items to share.
    NSArray *itemsToShare = @[textToShare, image];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare
                                                                             applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    
    [target presentViewController:activityVC animated:YES completion:nil];
}

@end
