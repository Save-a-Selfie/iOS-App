//
//  SASImageInspectorView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 06/06/2015.
//  Copyright (c) 2015 Peter Stephen Fox All rights reserved.
//

#import <UIKit/UIKit.h>

@class SASImageInspectorView;

@protocol SASImageInspectorDelegate <NSObject>

- (void) sasImageInspector:(SASImageInspectorView *) imageInspector userDidBeginMovingImage:(UIImage *) image withEvent:(UIEvent *) event;

@end

@interface SASImageInspectorView : UIView

- (instancetype)initWithImage:(UIImage*)image;

- (void) animateImageIntoView:(UIView *)view;

@end
