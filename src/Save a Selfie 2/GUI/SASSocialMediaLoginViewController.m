//
//  SASFacebookLoginViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 28/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//


#import "SASSocialMediaLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface SASSocialMediaLoginViewController ()

@property (weak, nonatomic) FBSDKLoginButton *fbLoginButton;
@property (weak, nonatomic) TWTRLogInButton *twtrLoginButton;
@property (strong, nonatomic) NSArray* buttons;

@end

@implementation SASSocialMediaLoginViewController


- (instancetype)initWithSocialMediaButtons:(NSArray *)buttons {
  self = [super init];
  if (self) {
    _buttons = buttons;
  }
  return self;
}


- (void) layoutButtons:(NSArray*) buttons {
  for (NSObject *button in buttons) {
    if ([button isKindOfClass:[FBSDKLoginButton class]]) { // Add Facebook login.
      self.fbLoginButton = (FBSDKLoginButton*)button;
      self.fbLoginButton.center = self.view.center;
      [self.view addSubview:self.fbLoginButton];
    }
    else if ([button isKindOfClass:[TWTRLogInButton class]]) { // Add twitter login button.
      self.twtrLoginButton = (TWTRLogInButton*)button;
      // Position in center.
      self.twtrLoginButton.center = self.view.center;
      // Change position.
      [self.twtrLoginButton setFrame:CGRectMake(self.twtrLoginButton.frame.origin.x,
                                                self.twtrLoginButton.frame.origin.y + 50,
                                                self.twtrLoginButton.frame.size.width,
                                                self.twtrLoginButton.frame.size.height)];
      
      [self.view addSubview:self.twtrLoginButton];
    }
  }
}



- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self layoutButtons:self.buttons];
}




@end
