//
//  FacebookVC.m
//
//  Created by Peter FitzGerald on 22/01/2013.
//  Copyright (c) 2013 Peter FitzGerald. All rights reserved.
//	from http://developers.facebook.com/docs/howtos/publish-to-feed-ios-sdk/#overview
//

#import "FacebookVC.h"
// #import "FacebookLogin.h"
#import "AlertBox.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"
#import "UIView+WidthXY.h"
#import "UploadPictureViewController.h"

@implementation FacebookVC

extern BOOL NSLogOn;
AlertBox *messageSent;
extern UIImage *photoImage;
//extern NSString *const FBUserIsLoggedIn;
float screenHeight, screenWidth;
AlertBox *FBAlert;

// **** need to check whether user is already logged in

- (void)viewDidLoad
{	
    [super viewDidLoad];
    plog(@"FBVC viewDidLoad");
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(FBUserIsLoggedIn)
//     name:FBUserIsLoggedIn
//     object:nil];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), screenHeight + 200);
//    [loginView moveObject:-200 overTimePeriod:0];
    [_skipFacebookLoginButton moveObject:screenHeight + 200 overTimePeriod:0];
    loginView.delegate = self;
    [self.view addSubview:loginView];
    [[_multilabelBackground layer] setCornerRadius:10.0f];
    [[_multilabelBackground layer] setMasksToBounds:YES];
    [_littleGuy moveObject:-100 overTimePeriod:0];
    _littleGuy.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_littleGuy moveObject:screenHeight * 0.5 - 70 overTimePeriod:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [_littleGuy bounceObject:20];});
        [_multipurposeLabel changeViewWidth:screenWidth - 52 atX:9999 centreIt:YES duration:0];
        [_multipurposeLabel setTextColor:[UIColor whiteColor]];
        [_multilabelBackground changeViewWidth:screenWidth - 40 atX:9999 centreIt:YES duration:0];
        [_multipurposeLabel moveObject:screenHeight + 100 overTimePeriod:0];
        _multipurposeLabel.hidden = NO;
        [_multipurposeLabel moveObject:screenHeight * 0.5 overTimePeriod:0.5];
        [_multilabelBackground moveObject:screenHeight + 100 overTimePeriod:0];
        _multilabelBackground.hidden = NO;
        [_multilabelBackground moveObject:screenHeight * 0.5 - 6 overTimePeriod:0.5];
        _multipurposeLabel.text = @"Welcome! If you have a Facebook account, you can login to it in order to share your selfies. Or tap 'Skip Facebook Login'";
        [loginView moveObject:screenHeight - 150 overTimePeriod:1];
        [_skipFacebookLoginButton moveObject:screenHeight - 75 overTimePeriod:1.25];
    });
    self.tabBarController.tabBar.hidden = YES;
}

//-(void)FBUserIsLoggedIn {
//    plog(@"in FBVC, user is logged in");
//    [self swapViewControllers];
//}

//// This method will be called when the user information has been fetched
//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
//                            user:(id<FBGraphUser>)user {
//    self.profilePictureView.profileID = user.id;
//    self.nameLabel.text = user.name;
//}
//
//// Logged-in user experience
//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    self.statusLabel.text = @"You're logged in as";
//}
//
//// Logged-out user experience
//- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
//    self.profilePictureView.profileID = nil;
//    self.nameLabel.text = @"";
//    self.statusLabel.text= @"You're not logged in!";
//}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    if (!FBAlert) {
        [[NSBundle mainBundle] loadNibNamed:@"AlertBox" owner:self options:nil];
        FBAlert = [[AlertBox alloc] initWithFrame:CGRectMake(20, 150, 260, 90)];
        FBAlert.center = self.view.center;
    }
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        plog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        plog(@"Unexpected error:%@", error);
    }
    
    [FBAlert fillAlertBox:alertTitle button1Text:alertMessage button2Text:nil action1:@selector(removeAlert) action2:nil calledFrom:self opacity:0.85 centreText:YES];
    [FBAlert addBoxToView:self.view withOrientation:0];

}

-(void)removeAlert { [FBAlert removeFromSuperview]; }

//-(void)swapViewControllers {
//    // if logged into Facebook, or if user has chosen to skip login, change to 'proper' first view controller
//    NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
//    plog(@"mArray: %@", mArray);
//    UploadPictureViewController *UPVC = [[UploadPictureViewController alloc] init];
//    [mArray replaceObjectAtIndex:1 withObject:UPVC];
//    [self.tabBarController setViewControllers:mArray animated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)skipFacebookLoginTapped:(id)sender {
}
@end
