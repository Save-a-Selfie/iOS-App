//
//  ThirdViewController.m
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 15/10/2014.
//  Copyright (c) 2014 Code for Ireland. All rights reserved.
//

#import "ThirdViewController.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"
#import "UIView+WidthXY.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

NSMutableData *responseData;
NSURLConnection *connection;
BOOL iPhone5;
extern UIFont *customFont;

- (void)viewDidAppear:(BOOL)animated {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat screenWidth = screenRect.size.width;
    [super viewDidAppear:animated];
    _littleGuy.hidden = YES;
    [[_multilabelBackground layer] setCornerRadius:10.0f];
    [[_multilabelBackground layer] setMasksToBounds:YES];
    [_littleGuy moveObject:-100 overTimePeriod:0];
    _littleGuy.hidden = NO;
    [_littleGuy moveObject:screenHeight - 268 overTimePeriod:0.5];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_littleGuy bounceObject:20];});
    [_multipurposeLabel changeViewWidth:screenWidth - 52 atX:9999 centreIt:YES duration:0];
    [_multilabelBackground changeViewWidth:screenWidth - 40 atX:9999 centreIt:YES duration:0];
    [_multipurposeLabel moveObject:screenHeight + 100 overTimePeriod:0];
    _multipurposeLabel.hidden = NO;
    [_multipurposeLabel moveObject:screenHeight - 202 overTimePeriod:0.5];
    [_multilabelBackground moveObject:screenHeight + 100 overTimePeriod:0];
    _multilabelBackground.hidden = NO;
    [_multilabelBackground moveObject:screenHeight - 206 overTimePeriod:0.5];
    _multipurposeLabel.text = @"Tap on the logos above to learn more about everyone involved.";
    _multipurposeLabel.font = customFont;

}

-(IBAction)buttonTapped:(id)sender {
    plog(@"button tapped: %d", ((UIButton *)sender).tag);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.iculture.info/saveaselfie/wp-content/themes/magazine-child/infoLink.php?button=%d", ((UIButton *)sender).tag]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
