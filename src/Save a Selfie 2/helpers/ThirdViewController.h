//
//  ThirdViewController.h
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 15/10/2014.
//  Copyright (c) 2014 Code for Ireland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
- (IBAction)buttonTapped:(id)sender;

@end

