//
//  Facebook.m
//

#import "FacebookLogin.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"

@interface FacebookLogin ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation FacebookLogin

@synthesize spinner;

extern BOOL NSLogOn;

#pragma mark -
#pragma mark Facebook Login Code

- (void)loginFailed {
	plog(@"login failed");
    // FBSample logic
    // Our UI is quite simple, so all we need to do in the case of the user getting
    // back to this screen without having been successfully authorized is to
    // stop showing our activity indicator. The user can initiate another login
    // attempt by clicking the Login button again.
    [self.spinner stopAnimating];
}

//- (void)loginToFacebook {
//	
//	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//	if (![appDelegate openSessionWithAllowLoginUI:NO]) {
//		plog(@"no open session");
//		[self.spinner startAnimating];
//		[appDelegate openSessionWithAllowLoginUI:YES];
//   }
//    
//    return;
//}

@end
