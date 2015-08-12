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
#import "Screen.h"

@interface SASInformationViewController ()

@property (strong, nonatomic) NSMutableArray *cardViews;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation SASInformationViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake([Screen width] * 4, [Screen height]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%f, %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.topItem.title = @"Information";
    
    
    SASSponsorCardView *fireBrigade = [[SASSponsorCardView alloc] init];
    fireBrigade.titleLabel.text = @"Dublin Fire Brigade";
    fireBrigade.imageView.image = [UIImage imageNamed:@"dublin fire brigade 300"];
    fireBrigade.button.titleLabel.text = @"More";
    fireBrigade.center = self.contentView.center;
    
    SASSponsorCardView *adamsGift = [[SASSponsorCardView alloc] init];
    adamsGift.titleLabel.text = @"Adams Gift";
    adamsGift.imageView.image = [UIImage imageNamed:@"AdamsGift"];
    adamsGift.button.titleLabel.text = @"More";
    adamsGift.center = self.contentView.center;
    adamsGift.frame = CGRectOffset(adamsGift.frame, [Screen width], 0);
    
    SASSponsorCardView *codeForIreland = [[SASSponsorCardView alloc] init];
    codeForIreland.titleLabel.text = @"Code For Ireland";
    codeForIreland.imageView.image = [UIImage imageNamed:@"Code for ireland logo"];
    codeForIreland.button.titleLabel.text = @"More";
    
    
    if (!self.cardViews) {
        self.cardViews = [[NSMutableArray alloc] initWithObjects:fireBrigade, adamsGift, nil, nil];
    }
    
    for (SASSponsorCardView *s in self.cardViews) {
        [self.scrollView addSubview:s];
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
