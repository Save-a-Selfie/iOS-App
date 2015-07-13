//
//  EULA.h
//  Save a Selfie
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



@class EULAView;

typedef NS_ENUM(NSInteger, EULAUserRespose) {
    EULAAccepted,
    EULADeclined
};

@protocol EULADelegate <NSObject>

- (void) eula:(EULAView *) eula didReceiveResponseFromUser:(EULAUserRespose) response;

@end

@interface EULAView : UIView

@property (weak, nonatomic) id <EULADelegate> delegate;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)EULALoaded;

@property (weak, nonatomic) IBOutlet UISegmentedControl *agreeDecline;


- (IBAction)agreeDeclineAction:(id)sender;

@end
