//
//  EULAView.h
//  Save a Selfie
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EULAResponse) {
    EULAResponseAccepted,
    EULAResponseDeclined
};


@class EULAViewController;


@protocol EULADelegate <NSObject>


// Messages the delegate what the user has responded.
// The response will be save to NSUserDefaults before
// it is forwarded to the delegate.
- (void) eulaView:(EULAViewController *) view userHasRespondedWithResponse:(EULAResponse) response;

@end

@interface EULAViewController : UIViewController

@property (weak, nonatomic) id <EULADelegate> delegate;

@property (weak, nonatomic) IBOutlet UIWebView* webView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


- (void) updateEULATable;


@end
