//
//  FacebookVC.m
//
// *** although Facebook is mentioned a lot here, in fact this is just a splash screen – Facebook is now handled via the Settings app and isAvailableForServiceType
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
extern NSString *const userSkippedLogin;
float screenHeight, screenWidth;
extern UIFont *customFont;
extern BOOL FBLoggedIn;
extern BOOL FBVCDisplayed;
//NSString *const loggedIntoFB;

// **** need to check whether user is already logged in

- (void)viewDidLoad
{	
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat screenWidth = screenRect.size.width;
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(changeFBVCDisplayed)
     name:@"FBVCDisplayed"
     object:nil];
    FBLoggedIn = [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
    plog(@"FBVC viewDidLoad with %d", FBLoggedIn);
    [[_multilabelBackground layer] setCornerRadius:10.0f];
    [[_multilabelBackground layer] setMasksToBounds:YES];
    [_littleGuy moveObject:-500 overTimePeriod:0]; // will not be using littleGuy here after all
    [_biggerGuy moveObject:-300 overTimePeriod:0];
    float biggerGuyWidth = MIN(screenWidth * 0.8, screenHeight * 0.3 + ((screenHeight > 481) ? ((screenHeight > 569) ? screenHeight * 0.2 : screenHeight * 0.1) : 0));
    if (biggerGuyWidth > _biggerGuy.frame.size.width) biggerGuyWidth = _biggerGuy.frame.size.width;
    [_biggerGuy changeViewWidth:biggerGuyWidth atX:0 centreIt:YES duration:0];
    [_skipFacebookLoginButton changeViewWidth:_skipFacebookLoginButton.frame.size.width atX:0 centreIt:YES duration:0];
    [_skipFacebookLoginButton moveObject:-100 overTimePeriod:0];
    [_slogan1 moveObject:-100 overTimePeriod:0];
    [_slogan2 moveObject:-100 overTimePeriod:0];
    [_slogan3 moveObject:-100 overTimePeriod:0];
    // copy slogans to create bold
    NSData *tempArchiveView = [NSKeyedArchiver archivedDataWithRootObject:_slogan1];
    UIView *slogan1b = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView];
    tempArchiveView = [NSKeyedArchiver archivedDataWithRootObject:_slogan2];
    UIView *slogan2b = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView];
    tempArchiveView = [NSKeyedArchiver archivedDataWithRootObject:_slogan3];
    UIView *slogan3b = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView];
    [slogan1b moveObject:-100 overTimePeriod:0];
    [slogan2b moveObject:-100 overTimePeriod:0];
    [slogan3b moveObject:-100 overTimePeriod:0];
    slogan1b.frame = CGRectMake(_slogan1.frame.origin.x + 1, _slogan1.frame.origin.y, _slogan1.frame.size.width, _slogan1.frame.size.height);
    slogan2b.frame = CGRectMake(_slogan2.frame.origin.x + 1, _slogan2.frame.origin.y, _slogan2.frame.size.width, _slogan2.frame.size.height);
    slogan3b.frame = CGRectMake(_slogan3.frame.origin.x + 1, _slogan3.frame.origin.y, _slogan3.frame.size.width, _slogan3.frame.size.height);
    [self.view addSubview:slogan1b];
    [self.view addSubview:slogan2b];
    [self.view addSubview:slogan3b];
    _littleGuy.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        plog(@"dispatch_after");
        [_biggerGuy moveObject:screenHeight * 0.22 overTimePeriod:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_biggerGuy bounceObject:20];});
        [_skipFacebookLoginButton moveObject:screenHeight * 0.7 overTimePeriod:1.25];
        [_slogan1 moveObject:screenHeight * 0.9 overTimePeriod:1.5];
        [_slogan2 moveObject:screenHeight * 0.85 overTimePeriod:1.6];
        [_slogan3 moveObject:screenHeight * 0.8 overTimePeriod:1.7];
        [slogan1b moveObject:screenHeight * 0.9 overTimePeriod:1.5];
        [slogan2b moveObject:screenHeight * 0.85 overTimePeriod:1.6];
        [slogan3b moveObject:screenHeight * 0.8 overTimePeriod:1.7 notification:@"FBVCDisplayed"];
    });
    self.tabBarController.tabBar.hidden = YES;
}

-(void)changeFBVCDisplayed { FBVCDisplayed = YES; }

- (IBAction)skipFacebookLoginTapped:(id)sender {
    plog(@"Continue! tapped");
	[[NSNotificationCenter defaultCenter] postNotificationName:userSkippedLogin object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
