
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
  [self.window makeKeyAndVisible];
  // Ask Facebook and Twitter who's repsonsible for login.
  return [self determineLoginMethod:application withOptions:launchOptions];
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
      [self presentAlertView:@"There was a problem logging into Twitter"];
    }
  };
  return twtrCompletionBlock;
}

// Determines the login, by asking Facebook and Twitter.
// If no login session, then user will be prompted to login.
- (BOOL) determineLoginMethod:(UIApplication*) application withOptions:(NSDictionary*) launchOptions {
  
  BOOL twitterSessionAvailable = NO;
  BOOL facebookSessionAvailable = NO;
  
  // This must be done for proper use of FBSDK. See documentation.
  [[FBSDKApplicationDelegate sharedInstance] application:application
                           didFinishLaunchingWithOptions:launchOptions];
  
  // This must be done to authenticate with Twitter.
  [[Twitter sharedInstance] startWithConsumerKey:@"e63HlqeNPwYcuMrLdpPLymZiW"
                                  consumerSecret:@"U8ePVS5OG8TlS2QM8mtg0BE2V4uJVgHwRkaBdKyfUQC6qrOWQF"];
  
  // Provide fabric with the classes we
  // want to use. (Fabric is Twitter's dev SDK)
  [Fabric with:@[[Twitter class]]];
  
  // Check if a user is logged in with Twitter.
  Twitter *twitter = [Twitter sharedInstance];
  if (!twitter.sessionStore.session) {
    
    twitterSessionAvailable = NO;
  } else {
    [twitter.sessionStore logOutUserID:twitter.session.userID];
    twitterSessionAvailable = YES;
  }
  
  // Check if logged into Facebook.
  if (![FBSDKAccessToken currentAccessToken]) {
    facebookSessionAvailable = NO;
  } else {
    facebookSessionAvailable = YES;
  }
  
  // If both social media platforms don't have a available
  // sessions, then the user must log in with one.
  if (!twitterSessionAvailable && !facebookSessionAvailable) {
    // Create Facebook login button.
    FBSDKLoginButton *fbLoginButton = [[FBSDKLoginButton alloc] init];
    fbLoginButton.readPermissions = @[@"public_profile", @"email"];
    fbLoginButton.loginBehavior = FBSDKLoginBehaviorNative;
    fbLoginButton.delegate = self;
    
    // Create Twitter login button.
    TWTRLogInButton *twtrLoginButton = [[TWTRLogInButton alloc] init];
    twtrLoginButton.logInCompletion = [self twtrLoginCompletion];
    
    NSArray *loginButtons = [NSArray arrayWithObjects:twtrLoginButton, fbLoginButton, nil];
    
    // Present user with option to sign in with Twitter or Facebook.
    self.socialMediaViewController = [[SASSocialMediaLoginViewController alloc] initWithSocialMediaButtons:loginButtons];
    self.window.rootViewController = self.socialMediaViewController;
  }
  else {
    // User has already logged into Twitter or Facebook, so just
    // open app normally.
    [self presentSASMapViewController];
  }
  return YES;
}



// Delegate callback for Facebook loginbutton.
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
    [signupWorker setFaceBookParam:@{@"fields" : @"id,name,email,picture"}];
    
    // Now that all Facebook params have
    // been set, begin sign up process.
    [self signUpUSerToSaveASelfie:signupWorker];
  }
}


- (void) signUpUSerToSaveASelfie:(DefaultSignUpWorker*) signupWorker {
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



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                        openURL:url
                                              sourceApplication:sourceApplication
                                                     annotation:annotation];
}



- (void) presentAlertView:(NSString*) message {
  NSLog(@"called");
  FXAlertController *alertController = [[FXAlertController alloc] initWithTitle:@"Error" message:message];
  FXAlertButton *button = [[FXAlertButton alloc] init];
  [button setTitle:@"Ok" forState:UIControlStateNormal];
  [alertController addButton:button];
  NSLog(@"%@", self.window.rootViewController);
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
