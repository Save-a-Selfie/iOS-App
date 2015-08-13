//
//  ThirdViewController.m
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 15/10/2014.
//  Copyright (c) 2014 Code for Ireland. All rights reserved.
//

#import "SASSponsorViewController.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"
#import "SASSponsorCardView.h"
#import "Screen.h"
#import "SASSponsorCardManager.h"



@interface SASSponsorViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *cardViews;

@end

@implementation SASSponsorViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"Sponsors";
    self.pageControl.numberOfPages = [SASSponsorCardManager sponsorAmount];
    
    self.cardViews = [SASSponsorCardManager allCards];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
    self.scrollView.contentSize = CGSizeMake([Screen width] * [SASSponsorCardManager sponsorAmount], 300);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
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




#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat xOffset = scrollView.contentOffset.x;
    self.pageControl.currentPage = [self determinePageIndex:xOffset];
}

#pragma Helper methods.
// Determines the page index from the scrollview offset.
// Pages start at 0 all the way up to n...
- (NSUInteger) determinePageIndex:(CGFloat) offset {
    
// TODO: This could be improved instead of checking for each page separately.
// However, there will most likely not be a large ammount of sponsors, so this could do.
    
    if (offset == [Screen width] * 0) {
        return 0;
    } else if (offset == [Screen width] * 1) {
        return 1;
    } else if (offset == [Screen width] * 2) {
        return 2;
    } else if (offset == [Screen width] * 3) {
        return 3;
    } else if (offset == [Screen width] * 4) {
        return 4;
    } else if (offset == [Screen width] * 5) {
        return 5;
    } else {
        return NSIntegerMax;
    }

}

@end
