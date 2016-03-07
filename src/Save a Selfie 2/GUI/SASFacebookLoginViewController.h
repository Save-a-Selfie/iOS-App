//
//  SASFacebookLoginViewController.h
//  Save a Selfie
//
//  Created by Stephen Fox on 28/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SASFacebookLoginViewController : UIViewController

/**
 Initialises a new instance with a loginButton.
 */
- (instancetype)initWithFBLoginButton:(FBSDKLoginButton*) loginButton;


@end
