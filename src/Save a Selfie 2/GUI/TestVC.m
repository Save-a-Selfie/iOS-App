//
//  TestVC.m
//  Save a Selfie
//
//  Created by Stephen Fox on 14/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "TestVC.h"
#import "EULAViewController.h"

@interface TestVC ()

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isViewLoaded && self.view.window != nil) {
        printf("FFF");
    }
        EULAViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EULAViewController"];

    [self presentViewController:vc animated:YES completion:nil];
}



@end
