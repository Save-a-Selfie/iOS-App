//
//  SASMapViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 27/05/2015.
//  Copyright (c) 2015 Peter FitzGerald. All rights reserved.
//

#import "SASMapViewController.h"
#import "SASMapView.h"
#include "Screen.h"

@interface SASMapViewController ()

@property(strong, nonatomic) SASMapView* sasMapView;
@property (strong, nonatomic) IBOutlet UIButton *locateUserButton;
@property (strong, nonatomic) IBOutlet UIButton *addImageButton;

@end

@implementation SASMapViewController

@synthesize sasMapView;
@synthesize locateUserButton;
@synthesize addImageButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    sasMapView = [[SASMapView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              [Screen width],
                                                              [Screen height])];
    [self.sasMapView locateUser];
    
    [self.view addSubview:sasMapView];
    [self.view bringSubviewToFront:locateUserButton];
    [self.view bringSubviewToFront:addImageButton];

}


- (IBAction)locateUser:(id)sender {
     [self.sasMapView locateUser];
}


@end
