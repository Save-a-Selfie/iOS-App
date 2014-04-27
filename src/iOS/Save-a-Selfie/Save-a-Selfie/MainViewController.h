//
//  MainViewController.h
//  Save-a-Selfie
//
//  Created by Magnus Deininger on 27/04/2014.
//  Copyright (c) 2014 Code for All Ireland. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
