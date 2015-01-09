//
//  ThirdViewController.h
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 15/10/2014.
//  Copyright (c) 2014 Code for Ireland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ThirdViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *multipurposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *multilabelBackground;
@property (weak, nonatomic) IBOutlet UIImageView *littleGuy;
- (IBAction)buttonTapped:(id)sender;

@end

