//
//  SASImageInspectorView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 06/06/2015.
//  Copyright (c) 2015 Stephen Fox All rights reserved.
//

#import <UIKit/UIKit.h>

@class SASImageInspectorView;


@protocol SASImageInspectorDelegate <NSObject>

- (void) sasImageInspectorView:(SASImageInspectorView *) inspector didDismiss:(BOOL) dismissed;

@end



@interface SASImageInspectorView : UIView


@property (nonatomic, weak) id<SASImageInspectorDelegate> delegate;

- (instancetype)initWithImage:(UIImage*)image;

- (void) animateImageIntoView:(UIView *)view;

@end
