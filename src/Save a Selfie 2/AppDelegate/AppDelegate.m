
//
//  AppDelegate.m
//  Save a Selfie 2
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import "AppDelegate.h"
#import "SASAppSharedPreferences.h"
#import "SASSocialMediaLoginViewController.h"
#import "SASMapViewController.h"
#import "FXAlert.h"
#import "SASNetworkManager.h"
#import "DefaultSignUpWorker.h"
#import "SASUser.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>


@interface AppDelegate () <FBSDKLoginButtonDelegate>

@property (strong, nonatomic) SASSocialMediaLoginViewController *socialMediaViewController;

@end

@implementation AppDelegate


UIFont *customFont, *customFontSmaller;

BOOL NSLogOn = NO; // YES to show logs, NO if not.

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  // Ask Facebook and Twitter who's repsonsible for login.
  return [self determineLoginMethod:application withOptions:launchOptions];
}



// Determines the login, by asking Facebook and Twitter.
- (BOOL) determineLoginMethod:(UIApplication*) application withOptions:(NSDictionary*) launchOptions {
  // This must be done for proper use of FBSDK. See documentation.
  BOOL r = [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
  
  // Check if logged into Twitter already.
  if (![FBSDKAccessToken currentAccessToken]) {
    FBSDKLoginButton *fbLoginButton = [[FBSDKLoginButton alloc] init];
    fbLoginButton.readPermissions = @[@"public_profile", @"email"];
    fbLoginButton.loginBehavior = FBSDKLoginBehaviorNative;
    fbLoginButton.delegate = self;

    // Check if logged into Twitter.
    TWTRLogInButton *twtrLogInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
      if (!session) {
        NSArray *loginButtons = [NSArray arrayWithObjects:fbLoginButton, twtrLogInButton, nil];
        self.socialMediaViewController = [[SASSocialMediaLoginViewController alloc] initWithSocialMediaButtons:loginButtons];
        self.window.rootViewController = self.socialMediaViewController;
      }
    }];
  }
  else {
    // User has already logged into Twitter or Facebook, so just
    // open app normally.
    [self presentSASMapViewController];
  }
  return r;
}


- (void) twitterLogin {
  [Fabric with:@[[Twitter class]]];
}



- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
  if (error) {
    [self presentAlertView:@"There was a problem logging into Facebook."];
  }
  else if (result.isCancelled) { }
  // Make sure we have access to all info we need.
  else if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"public_profile"] ||
           ![[FBSDKAccessToken currentAccessToken] hasGranted:@"email"]) {
    [self presentAlertView:@"There was a problem logging into Facebook."];
  } else {
    
    // Signup user to save a selfie server.
    DefaultSignUpWorker *signupWorker = [[DefaultSignUpWorker alloc] init];
    [signupWorker setParam:@{@"fields" : @"id,name,email,picture"}];
    
    SASNetworkManager *networkManager = [SASNetworkManager sharedInstance];
    [networkManager signUpWithWorker:signupWorker completion:^(NSString *email, NSString *token, SignUpWorkerResponse response) {
      switch (response) {
        case SignUpWorkerResponseFailed:
          [self presentAlertView:@"There was a problem trying to sign you up."];
          break;
        case SignUpWorkerResponseUserExists:
          NSLog(@"User exists but we should sign them in now");
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
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                        openURL:url
                                              sourceApplication:sourceApplication
                                                     annotation:annotation];
}



- (void) presentAlertView:(NSString*) message {
  FXAlertController *alertController = [[FXAlertController alloc] initWithTitle:@"Error" message:message];
  FXAlertButton *button = [[FXAlertButton alloc] init];
  [button setTitle:@"Ok" forState:UIControlStateNormal];
  [alertController addButton:button];
  [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


- (void) presentSASMapViewController {
  UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  
  UITabBarController *tabBarController = [mainStory instantiateViewControllerWithIdentifier:@"TabBarController"];
  self.window.rootViewController = tabBarController;
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
  // Remove the current logged in user.
  [SASUser removeCurrentLoggedUser];
}


@end
