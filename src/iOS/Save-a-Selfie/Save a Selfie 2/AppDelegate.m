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
BOOL FBVCDisplayed = NO; // will change to YES if FacebookVC gets to finish displaying
NSString *const objectChosen = @"object chosen"; // will be used in EmergencyObjects.m
NSString *const userSkippedLogin = @"user skipped login";
NSString *const applicationWillEnterForeground = @"application returned to foreground"; // may have left to sort out permissions issues
UIFont *customFont, *customFontSmaller;

BOOL NSLogOn = YES; // YES to show logs, NO if not

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    plog(@"Launching");
    customFont = [UIFont fontWithName:@"TradeGothic LT" size:17];
    customFontSmaller = [UIFont fontWithName:@"TradeGothic LT" size:14];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self selector:@selector(swapViewControllers)
	 name:userSkippedLogin
	 object:nil];
    return YES;
}

-(void)swapViewControllers {
    // if logged into Facebook, or if user has chosen to skip login, change to 'proper' first view controller
//    ((UITabBarController*)self.window.rootViewController).selectedViewController;
    
    if (FBVCDisplayed) { // continue only if user has seen FacebookVC screen
        plog(@"Root: %@", self.window.rootViewController);
        UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:tabController.viewControllers];
        plog(@"mArray: %@", mArray);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UploadPictureViewController *UPVC = [storyboard instantiateViewControllerWithIdentifier:@"UploadPictureViewController"];
        [mArray replaceObjectAtIndex:0 withObject:UPVC];
        [tabController setViewControllers:mArray animated:NO];
    }
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
