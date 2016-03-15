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
#import "DefaultSignUpWorker.h"
#import "SASNetworkManager.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "FXAlert.h"
#import "SASUser.h"


@interface SASSocialMediaLoginViewController () <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) FBSDKLoginButton *fbLoginButton;
@property (weak, nonatomic) TWTRLogInButton *twtrLoginButton;
@property (strong, nonatomic) NSArray* buttons;
@property (strong, nonatomic) NSString *errorMessage;

@end

@implementation SASSocialMediaLoginViewController


- (instancetype)initWithSocialMediaButtons:(NSArray *)buttons {
  self = [super init];
  if (self) {
    _buttons = buttons;
    [self setUpButtons:buttons];
  }
  return self;
}


- (void) setUpButtons:(NSArray*) buttons {
  for (NSObject *button in buttons) {
    if ([button isKindOfClass:[FBSDKLoginButton class]]) { // Add Facebook login.
      self.fbLoginButton = (FBSDKLoginButton*)button;
      self.fbLoginButton.center = self.view.center;
      self.fbLoginButton.delegate = self;
      [self.view addSubview:self.fbLoginButton];
    }
    else if ([button isKindOfClass:[TWTRLogInButton class]]) { // Add twitter login button.
      self.twtrLoginButton = (TWTRLogInButton*)button;
      // Position in center.
      self.twtrLoginButton.center = self.view.center;
      self.twtrLoginButton.logInCompletion = [self twtrLoginCompletion];
      // Change position.
      [self.twtrLoginButton setFrame:CGRectMake(self.twtrLoginButton.frame.origin.x,
                                                self.twtrLoginButton.frame.origin.y + 50,
                                                self.twtrLoginButton.frame.size.width,
                                                self.twtrLoginButton.frame.size.height)];
    }
  }
}



- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  // Buttons should be correctly setup.
  [self.view addSubview:self.twtrLoginButton];
  [self.view addSubview:self.fbLoginButton];
}


// Return reference to a block that can
// handle TWTRLogInCompletion.
- (TWTRLogInCompletion) twtrLoginCompletion {
  TWTRLogInCompletion twtrCompletionBlock = ^(TWTRSession *session,  NSError * error) {
    if (session) {
      DefaultSignUpWorker *signUpWorker = [[DefaultSignUpWorker alloc] init];
      // Give the user id of the user logged in so the
      // sign up worker can use it to get information from
      // twitter.
      [signUpWorker setTwitterParam:@{@"userId" : session.userID}];
      [self signUpUSerToSaveASelfie:signUpWorker];
    } else {
      self.errorMessage = @"There was a problem logging into Twitter";
    }
  };
  return twtrCompletionBlock;
}

- (void)viewDidAppear:(BOOL)animated {
  // Present alertView as this is
  // the only time we know we're in the
  // window hierarchy.
  [self presentAlertView];
}

// Delegate callback for Facebook loginbutton.
- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
  if (error) {
    self.errorMessage = @"There was a problem logging into Facebook.";
  }
  else if (result.isCancelled) { }
  // Make sure we have access to all info we need.
  else if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"public_profile"] ||
           ![[FBSDKAccessToken currentAccessToken] hasGranted:@"email"]) {
    self.errorMessage = @"There was a problem logging into Facebook.";
  } else {
    
    // Signup user to save a selfie server.
    DefaultSignUpWorker *signupWorker = [[DefaultSignUpWorker alloc] init];
    [signupWorker setFaceBookParam:@{@"fields" : @"id,name,email,picture"}];
    
    // Now that all Facebook params have
    // been set, begin sign up process.
    [self signUpUSerToSaveASelfie:signupWorker];
  }
}


// Signs users who have given the app the correct permissions
// from their social media handle.
- (void) signUpUSerToSaveASelfie:(DefaultSignUpWorker*) signupWorker {
  SASNetworkManager *networkManager = [SASNetworkManager sharedInstance];
  [networkManager signUpWithWorker:signupWorker completion:^(NSString *email, NSString *token, SignUpWorkerResponse response) {
    switch (response) {
      case SignUpWorkerResponseFailed:
        self.errorMessage = @"There was a problem trying to sign you up";
        break;
      case SignUpWorkerResponseUserExists:
        // User's already signed up; Sign them in.
        [SASUser setCurrentLoggedUser:token withEmail:email];
        // Now let user into app.
        [self presentSASMapViewController];
        break;
      case SignUpWorkerResponseSuccess:
        // New account. Sign them in.
        [SASUser setCurrentLoggedUser:token withEmail:email];
        // Now let user into app.
        [self presentSASMapViewController];
        break;
      default:
        break;
    }}];
}


// This method will present any alerts
// if the property -[self errorMessage] is set.
// Please don't call this method directly as
// this ViewController presents and dismisses
// many views for signups, so there is a chance
// it will be called incorrectly at the wrong time
// and thus an alert wont be shown to the user.
- (void) presentAlertView {
  if (!self.errorMessage || [self.errorMessage isEqualToString:@""]) {
    return;
  }
  FXAlertController *alertController = [[FXAlertController alloc] initWithTitle:@"Error" message:self.errorMessage];
  FXAlertButton *button = [[FXAlertButton alloc] init];
  [button setTitle:@"Ok" forState:UIControlStateNormal];
  [alertController addButton:button];
  [self presentViewController:alertController animated:YES completion:nil];
  // Remove reference to error message.
  self.errorMessage = nil;
}

- (void) presentSASMapViewController {
  UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:[NSBundle mainBundle]];
  UITabBarController *tabBarController = [mainStory instantiateViewControllerWithIdentifier:@"TabBarController"];
  [self presentViewController:tabBarController animated:YES completion:nil];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
  // Remove the current logged in user.
  [SASUser removeCurrentLoggedUser];
}




@end
