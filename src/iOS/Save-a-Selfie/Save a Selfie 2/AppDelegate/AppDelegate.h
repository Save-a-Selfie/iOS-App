//
//  AppDelegate.h
//  Save a Selfie 2
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import <UIKit/UIKit.h>
#define plog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

-(void)swapViewControllers;
@end

