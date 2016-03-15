
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


@interface AppDelegate ()

@property (strong, nonatomic) SASSocialMediaLoginViewController *socialMediaViewController;


@end

@implementation AppDelegate


UIFont *customFont, *customFontSmaller;

BOOL NSLogOn = NO; // YES to show logs, NO if not.

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self.window makeKeyAndVisible];
  
  // This must be done for proper use of FBSDK. See documentation.
  [[FBSDKApplicationDelegate sharedInstance] application:application
                           didFinishLaunchingWithOptions:launchOptions];
  // This must be done to authenticate with Twitter.
  [[Twitter sharedInstance] startWithConsumerKey:@"e63HlqeNPwYcuMrLdpPLymZiW"
                                  consumerSecret:@"U8ePVS5OG8TlS2QM8mtg0BE2V4uJVgHwRkaBdKyfUQC6qrOWQF"];
  // Determine the login method.
  return [self determineLoginMethod];
}


// Determines the login, by asking Facebook and Twitter.
// If no login session, then user will be prompted to login.
- (BOOL) determineLoginMethod {
  
  BOOL twitterSessionAvailable = NO;
  BOOL facebookSessionAvailable = NO;
  
  // Check if the user has a Save a Selfie
  // authorization token before checking
  // social media.
  if (![[SASUser currentLoggedUser] objectForKey:USER_DICT_TOKEN]) {
    [self beginSignUpProcess];
    return YES;
  }
  
  // Provide fabric with the classes we
  // want to use. (Fabric is Twitter's dev SDK)
  [Fabric with:@[[Twitter class]]];
  
  // Check if a user is logged in with Twitter.
  Twitter *twitter = [Twitter sharedInstance];
  if (!twitter.sessionStore.session) {
    twitterSessionAvailable = NO;
  } else {
    //[twitter.sessionStore logOutUserID:twitter.session.userID];
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
    [self beginSignUpProcess];
  }
  else {
    // User has already logged into Twitter or Facebook, so just
    // open app normally.
    [self presentSASMapViewController];
  }
  return YES;
}

- (void) beginSignUpProcess {
  // Create Facebook login button.
  FBSDKLoginButton *fbLoginButton = [[FBSDKLoginButton alloc] init];
  fbLoginButton.readPermissions = @[@"public_profile", @"email"];
  fbLoginButton.loginBehavior = FBSDKLoginBehaviorNative;
  
  // Create Twitter login button.
  TWTRLogInButton *twtrLoginButton = [[TWTRLogInButton alloc] init];
  
  NSArray *loginButtons = [NSArray arrayWithObjects:twtrLoginButton, fbLoginButton, nil];
  
  // Present user with option to sign in with Twitter or Facebook.
  self.socialMediaViewController = [[SASSocialMediaLoginViewController alloc] initWithSocialMediaButtons:loginButtons];
  self.window.rootViewController = self.socialMediaViewController;
}


- (void) presentSASMapViewController {
  UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  
  UITabBarController *tabBarController = [mainStory instantiateViewControllerWithIdentifier:@"TabBarController"];
  self.window.rootViewController = tabBarController;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                        openURL:url
                                              sourceApplication:sourceApplication
                                                     annotation:annotation];
}



@end
