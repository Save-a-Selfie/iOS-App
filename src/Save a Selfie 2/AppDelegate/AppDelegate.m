//
//  AppDelegate.m
//  Save a Selfie 2
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"

#import "UploadPictureViewController.h"
#import "SASUtilities.h"

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

BOOL NSLogOn = NO; // YES to show logs, NO if not

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    plog(@"Launching");
        return YES;
}



#pragma mark Events

- (void)applicationDidEnterBackground:(UIApplication *)application {
    plog(@"entering background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
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
