//
//  SASNotificationView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 10/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASNotificationView : UIView

@property(weak, nonatomic) NSString* title;
@property(weak, nonatomic) UIImage *image;

- (void) animateIntoView:(UIView *) view;

@end
