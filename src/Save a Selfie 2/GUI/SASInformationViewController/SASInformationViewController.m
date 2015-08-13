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
#import "SASSponsorCardManager.h"

@interface SASInformationViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *cardViews;

@end

@implementation SASInformationViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"Information";
    self.pageControl.numberOfPages = [SASSponsorCardManager sponsorAmount];
    
    self.cardViews = [SASSponsorCardManager allCards];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
    self.scrollView.contentSize = CGSizeMake([Screen width] * [SASSponsorCardManager sponsorAmount], 300);
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    int counter = 0;
    for (SASSponsorCardView *s in self.cardViews) {
        [self.scrollView addSubview:s];
        [self addView:s toPage:counter];
        counter++;
    }
    
}

// As this scrollView is paged, this method will simply just offset
// the view passed to a specific page and center it on the scroll
// view.
- (void) addView:(UIView *) view toPage:(NSUInteger) page {
    view.center = self.scrollView.center;
    view.frame = CGRectOffset(view.frame, [Screen width] * page, 0);
}

- (IBAction)openAdamsGift:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/pages/Adams-Gift/334232113442348"]];
}


@end
