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
    [_littleGuy moveObject:screenHeight * 0.66 - 50 overTimePeriod:0.5];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_littleGuy bounceObject:20];});
    [_multipurposeLabel changeViewWidth:screenWidth - 52 atX:9999 centreIt:YES duration:0];
    [_multilabelBackground changeViewWidth:screenWidth - 40 atX:9999 centreIt:YES duration:0];
    [_multipurposeLabel moveObject:screenHeight + 100 overTimePeriod:0];
    _multipurposeLabel.hidden = NO;
    [_multipurposeLabel moveObject:screenHeight * 0.66 overTimePeriod:0.5];
    [_multilabelBackground moveObject:screenHeight + 100 overTimePeriod:0];
    _multilabelBackground.hidden = NO;
    [_multilabelBackground moveObject:screenHeight * 0.66 - 4 overTimePeriod:0.5];
    _multipurposeLabel.text = @"Tap on the logos above to learn more about everyone involved.";
    _multipurposeLabel.font = customFont;
    _button1.center = CGPointMake(screenWidth * 0.3, -200);
    [_button1 moveObject:screenHeight * 0.2 - _button1.frame.size.height * 0.5 overTimePeriod:0.5];
    _button2.center = CGPointMake(screenWidth * 0.7, -200);
    [_button2 moveObject:screenHeight * 0.2 - _button2.frame.size.height * 0.5 overTimePeriod:0.5];
    _button3.center = CGPointMake(screenWidth * 0.3, -200);
    [_button3 moveObject:screenHeight * 0.4 - _button3.frame.size.height * 0.5 overTimePeriod:0.75];
    _button4.center = CGPointMake(screenWidth * 0.7, -200);
    [_button4 moveObject:screenHeight * 0.4 - _button4.frame.size.height * 0.5 overTimePeriod:0.75];
}

-(IBAction)buttonTapped:(id)sender {
    plog(@"button tapped: %d", ((UIButton *)sender).tag);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/infoLink.php?button=%ld", (long)((UIButton *)sender).tag]]];
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
