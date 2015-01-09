//
//  PopupImage.m
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 28/12/2014.
//  Copyright (c) 2014 Peter FitzGerald. All rights reserved.
//

#import "PopupImage.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"

@implementation PopupImage

- (IBAction)closePopup:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"close popup" object:nil];
}

@end
