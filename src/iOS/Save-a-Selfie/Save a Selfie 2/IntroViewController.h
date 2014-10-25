//
//  IntroViewController.h
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 18/10/2014.
//  Copyright (c) 2014 Code for Ireland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *choose;
- (IBAction)choiceChosen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *snapButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
- (IBAction)showUpload:(id)sender;
- (IBAction)showWebsite:(id)sender;

@end
