//
//  FacebookVC.h
//  IMMA
//
//  Created by Peter FitzGerald on 22/01/2013.
//  Copyright (c) 2013 Peter FitzGerald. All rights reserved.
//	from http://developers.facebook.com/docs/howtos/publish-to-feed-ios-sdk/#overview
//

#import <UIKit/UIKit.h>
#import "FBProtocols.h"
//#import <FacebookSDK/FBRequest.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookVC : UIViewController <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *multipurposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *multilabelBackground;
@property (weak, nonatomic) IBOutlet UIImageView *littleGuy;
@property (weak, nonatomic) IBOutlet UIImageView *FBUserFace;
@property (weak, nonatomic) IBOutlet UIButton *skipFacebookLoginButton;
- (IBAction)skipFacebookLoginTapped:(id)sender;
@end
