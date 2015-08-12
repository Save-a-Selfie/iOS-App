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
#import "SASSponsorCardView.h"

@interface SASInformationViewController ()

@property (strong, nonatomic) SASSponsorCardView *cardView;

@end

@implementation SASInformationViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(!self.cardView) {
        self.cardView = [[SASSponsorCardView alloc] init];
        self.cardView.imageView.image = [UIImage imageNamed:@"AdamsGift"];
        self.cardView.titleLabel.text = @"Adams Gift";
        self.cardView.center = self.view.center;
        [self.view addSubview:self.cardView];
    }
    
    
}

- (IBAction)buttonTapped:(id)sender {
    plog(@"button tapped: %d", ((UIButton *)sender).tag);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/infoLink.php?button=%ld", (long)((UIButton *)sender).tag]]];
}

- (IBAction)openAdamsGift:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/pages/Adams-Gift/334232113442348"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
