//
//  AppDelegate.m
//  Save a Selfie 2
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

NSString *const applicationWillEnterForeground = @"application returned to foreground"; // for detail – to check that current photo wasn't just deleted
BOOL NSLogOn = YES; // YES to show logs, NO if not

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    plog(@"Launching");
//    IntroViewController *intro = [[IntroViewController alloc] initWithNibName:@"LoginViewController" bundle:NULL];
//    self.window.rootViewController = TabarViewController;
//    [self.window.rootViewController presentViewController:intro animated:NO completion:nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

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
