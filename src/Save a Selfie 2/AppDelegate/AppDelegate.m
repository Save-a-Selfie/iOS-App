//
//  AppDelegate.m
//  Save a Selfie 2
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import "AppDelegate.h"
#import "SASAppUserDefaults.h"
#import "SASFacebookLoginViewController.h"
#import "SASMapViewController.h"
#import "FXAlert.h"
#import "SASNetworkManager.h"
#include "DefaultSignUpWorker.h"


@interface AppDelegate () <FBSDKLoginButtonDelegate>

@property (strong, nonatomic) FBSDKLoginButton *fbLoginButton;
@property (strong, nonatomic) SASFacebookLoginViewController *fbViewController;

@end

@implementation AppDelegate


UIFont *customFont, *customFontSmaller;

BOOL NSLogOn = NO; // YES to show logs, NO if not

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  // Check if logged into facebook already.
  if (![FBSDKAccessToken currentAccessToken]) {
    self.fbLoginButton = [[FBSDKLoginButton alloc] init];
    self.fbLoginButton.readPermissions = @[@"public_profile", @"email"];
    self.fbLoginButton.loginBehavior = FBSDKLoginBehaviorNative;
    self.fbLoginButton.delegate = self;
    self.fbViewController = [[SASFacebookLoginViewController alloc]
                             initWithFBLoginButton:self.fbLoginButton];
    self.window.rootViewController = self.fbViewController;
  }
  else {
    [self presentSASMapViewController];
  }
  return YES;
}


- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
  if (error) {
    [self displayFBLoginErrorAlert];
  }
  else if (result.isCancelled) {
    
  }
  else {
    // Make sure we have access to all info we need.
    if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"public_profile"] ||
        ![[FBSDKAccessToken currentAccessToken] hasGranted:@"email"]) {
      [self displayFBLoginErrorAlert];
      return;
    }

    // Signup user to save a selfie server.
    DefaultSignUpWorker *signupWorker = [[DefaultSignUpWorker alloc] init];
    [signupWorker setParam:@{@"fields" : @"id,name,email,picture"}];
    
    SASNetworkManager *networkManager = [SASNetworkManager sharedInstance];
    [networkManager signUpWithWorker:signupWorker completion:^(void) {}];

    [self presentSASMapViewController];
  }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                        openURL:url
                                              sourceApplication:sourceApplication
                                                     annotation:annotation];
}


- (void) displayFBLoginErrorAlert {
  FXAlertController *alertView = [[FXAlertController alloc] initWithTitle:@"Failed"
                                                                  message:@"There was a problem trying to log you into facebook."];
  FXAlertButton *okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeStandard];
  [alertView addButton:okButton];
  [self.window.rootViewController presentViewController:alertView animated:YES completion:nil];
}


- (void) presentSASMapViewController {
  UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  
  UITabBarController *tabBarController = [mainStory instantiateViewControllerWithIdentifier:@"TabBarController"];
  self.window.rootViewController = tabBarController;
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
}


@end
