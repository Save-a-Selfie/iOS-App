#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class FacebookLogin;

@interface FacebookLogin : UIResponder <UIApplicationDelegate>

- (void)loginToFacebook;
- (void)loginFailed;

@end
