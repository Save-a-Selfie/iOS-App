//
//  EULA.h
//  Save a Selfie
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EULA : UIView

@property (strong, nonatomic) IBOutlet UIWebView *webView;
//- (IBAction)userAgreed:(id)sender;
- (void)EULALoaded;
@property (strong, nonatomic) IBOutlet UISegmentedControl *agreeDecline;
- (IBAction)agreeDeclineAction:(id)sender;

@end
