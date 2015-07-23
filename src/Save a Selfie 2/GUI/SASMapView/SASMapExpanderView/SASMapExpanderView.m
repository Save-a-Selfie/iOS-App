//
//  SASMapExpanderView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 23/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASMapExpanderView.h"
#import "Screen.h"

@interface SASMapExpanderView()


@property (strong, nonatomic) SASMapView *sasMapView;
@property (strong, nonatomic) UIButton *closeButton;

@end


@implementation SASMapExpanderView

@synthesize sasMapView = _sasMapView;
@synthesize closeButton = _closeButton;

- (instancetype) initWithMap:(SASMapView *) mapView {
    if(self = [super init]) {
        
        _sasMapView = [mapView copy];

        self.frame = _sasMapView.frame;
        
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        _closeButton.imageView.image = [UIImage imageNamed:@"Watermark"];

        [self addSubview:_sasMapView];
        [self addSubview:_closeButton];
    }
    return self;
}


#pragma Animations
- (void) animateIntoView:(UIView *) view {
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController.view addSubview:self];
    [rootViewController.view bringSubviewToFront:self];

    [UIView animateWithDuration:0.4 animations:^{
        
        
    }];
    

}

@end
