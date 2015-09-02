
#import <UIKit/UIKit.h>
#import "FXAlertButton.h"

/**
 An alernative alert to the native iOS UIAlertController
 and UIAlertView. This class alows for a title, message and a maximum,
 of two buttons. Customise each button like you would any UIButton instance.
 Use FXAlertController's custom method's to set the colour/ font
 of the message, title or each button subview.
 */
@interface FXAlertController : UIViewController





/**
 Initialises a new instance with a title
 and message set.
 
 @param title   The title of the alert.
 @param message The message of the alert.
 
 @return New instance
 */
- (instancetype) initWithTitle:(NSString *) title message:(NSString *) message;



/**
 Adds a button to the receiver. The sizing and positioning of the buttons
 is handled internally by the FXAlertView class.
 
 Each instance of FXAlertView can only have a maximum of two buttons at a time.
 A "Standard" button (left side) and a "Cancel" button (right side).
 
 - If there is one button on the view it will take up the whole
 width of the alert.
 - If there is two buttons on the view, they will each share half the width
 of the FXAlertView instance.
 
 @param button An instance of FXAlertButton.
 */
- (void) addButton:(FXAlertButton *) button;




/**
 Use this property for quick setup
 of setting the colours of the standardButton.
 
 It is possible to change the colour of the button
 by accessing the button itself. 
 
 The default colour is:
    RBG:
    HEX:
 */
@property (strong, nonatomic) UIColor *standardButtonColour;




/**
 Use this property for quick setup
 of setting the colours of the cancel.
 
 It is possible to change the colour of the button
 by accessing the button itself.
 
 The default colour is:
 RBG:
 HEX:
 */
@property (strong, nonatomic) UIColor *cancelButtonColour;



/**
 Use this property to change the font
 of the message and buttons.
 
 The default font is "Avenir Next", size:18
 */
@property (strong, nonatomic) UIFont *font;



/**
 Use this propert to change the font
 of the title on the alert.
 
 The default font is "AvenirNext-DemiBold, size:20
 */
@property (strong, nonatomic) UIFont *titleFont;




@end
