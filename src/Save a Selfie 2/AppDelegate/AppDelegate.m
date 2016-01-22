//
//  AppDelegate.m
//  Save a Selfie 2
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


UIFont *customFont, *customFontSmaller;

BOOL NSLogOn = NO; // YES to show logs, NO if not

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [Parse setApplicationId:@"pidt6nz9C05S46ykNMXZQPunAPjIULBwnfbrjpVz"
                clientKey:@"tMAXH4AeFLkeM2b8weuZe5IlNeU7AbuXe2wLmWtG"];
  return YES;
}


@end
