//
//  ThirdViewController.m
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 15/10/2014.
//  Copyright (c) 2014 Code for Ireland. All rights reserved.
//

#import "SASInformationViewController.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"
#import "UIView+WidthXY.h"

@interface SASInformationViewController ()

@end

@implementation SASInformationViewController



- (IBAction)buttonTapped:(id)sender {
    plog(@"button tapped: %d", ((UIButton *)sender).tag);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/infoLink.php?button=%ld", (long)((UIButton *)sender).tag]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
