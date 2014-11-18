//
//  AppDelegate.m
//  Save a Selfie 2
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UploadPictureViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

int chosenObject;
BOOL FBLoggedIn = NO;
NSString *facebookUsername;
NSString *const objectChosen = @"object chosen"; // will be used in EmergencyObjects.m
NSString *const userSkippedLogin = @"user skipped login";
NSString *const applicationWillEnterForeground = @"application returned to foreground"; // may have left to sort out permissions issues

BOOL NSLogOn = YES; // YES to show logs, NO if not

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    plog(@"Launching");
    [FBLoginView class];
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
	[[NSNotificationCenter defaultCenter]
	 addObserver:self selector:@selector(swapViewControllers)
	 name:userSkippedLogin
	 object:nil];

    return YES;
}

#pragma mark Faceboook

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL b = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    plog(@"FB response with %d", [FBSession activeSession].state);
    FBLoggedIn = 513 == [FBSession activeSession].state; // see http://stackoverflow.com/questions/12502272/authentication-using-facebook-id-facebook-sdk-ios
    if (FBLoggedIn) { [self getFacebookInfo]; plog(@"1 < user is %@", facebookUsername); [self swapViewControllers]; }
    return b;
}

-(void)getFacebookInfo {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) { if (!error) {}
         }];
    }
    
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSString *firstName = user.first_name;
                 NSString *lastName = user.last_name;
                 NSString *facebookId = user.objectID;
                 NSString *email = [user objectForKey:@"email"];
                 //                     NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
                 facebookUsername = [NSString stringWithFormat:@"%@ %@ (%@, %@)", firstName, lastName, facebookId, email];
                 plog(@"4 < user is %@", facebookUsername);
             }
         }];
    }
}

// This method will handle ALL the session state changes in the app (only it doesn't recognise a new session for some reason, if you log out and then back in).
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        plog(@"Session opened");
        [self getFacebookInfo]; plog(@"2 < user is %@", facebookUsername);
        [self swapViewControllers];
        // Show the user the logged-in UI
        FBLoggedIn = YES; // [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        plog(@"Session closed");
        // Show the user the logged-out UI
        FBLoggedIn = NO; // [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        plog(@"Error");
        FBLoggedIn = NO;
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            plog(@"%@: %@", alertText, alertText); //[self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                plog(@"User cancelled login");
                
            // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
//                [self showMessage:alertText withTitle:alertTitle];
                plog(@"%@: %@", alertText, alertText);
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                plog(@"%@: %@", alertText, alertText);
//                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        // Show the user the logged-out UI
        FBLoggedIn = NO; // [self userLoggedOut];
    }
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    [self getFacebookInfo];
    plog(@"3 < user is %@", facebookUsername);
}

-(void)swapViewControllers {
    // if logged into Facebook, or if user has chosen to skip login, change to 'proper' first view controller
//    ((UITabBarController*)self.window.rootViewController).selectedViewController;
    plog(@"Root: %@", self.window.rootViewController);
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:tabController.viewControllers];
    plog(@"mArray: %@", mArray);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UploadPictureViewController *UPVC = [storyboard instantiateViewControllerWithIdentifier:@"UploadPictureViewController"];
    [mArray replaceObjectAtIndex:0 withObject:UPVC];
    [tabController setViewControllers:mArray animated:NO];
}

#pragma mark Events

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    plog(@"entering background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    plog(@"entering foreground");
    [[NSNotificationCenter defaultCenter] postNotificationName:applicationWillEnterForeground object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
