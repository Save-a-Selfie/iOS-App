//
//  TabBarController.m
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 18/10/2014.
//  Copyright (c) 2014 Code for Ireland. All rights reserved.
//

#import "TabBarController.h"
#import "WebsiteViewController.h"
#import "UploadPictureViewController.h"
#import "AppDelegate.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBar.barTintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1.0];
//    self.tabBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
