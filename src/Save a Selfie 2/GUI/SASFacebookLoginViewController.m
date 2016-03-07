//
//  SASFacebookLoginViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASFacebookLoginViewController.h"


@interface SASFacebookLoginViewController ()

@property (weak, nonatomic) FBSDKLoginButton *loginButton;

@end

@implementation SASFacebookLoginViewController

- (instancetype)initWithFBLoginButton:(FBSDKLoginButton*) loginButton {
  self = [super init];
  if (!self) {
    return self;
  }
  _loginButton = loginButton;
  _loginButton.center = self.view.center;
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.loginButton.center = self.view.center;
  [self.view addSubview:self.loginButton];
}




@end
