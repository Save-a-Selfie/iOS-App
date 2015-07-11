//
//  AppDelegate.m
//  Save a Selfie 2
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"

#import "SASUtilities.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


UIFont *customFont, *customFontSmaller;

BOOL NSLogOn = NO; // YES to show logs, NO if not

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}



#pragma mark Events

- (void)applicationDidEnterBackground:(UIApplication *)application {
    plog(@"entering background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    plog(@"entering foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
