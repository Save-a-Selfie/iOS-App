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

@end

@implementation SASMapViewController

@synthesize sasMapView;
@synthesize locateUserButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    sasMapView = [[SASMapView alloc] init];
    [self.sasMapView locateUser];
    
    [self.view addSubview:sasMapView];
    [self.view bringSubviewToFront:locateUserButton];

}

- (IBAction)locateUser:(id)sender {
     [self.sasMapView locateUser];
}


@end
