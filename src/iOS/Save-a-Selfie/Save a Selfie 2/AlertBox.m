//
//  AlertBox.m
//  Photoapp4it
//
//  Created by Peter FitzGerald on 23/05/2013.
//

#import "AlertBox.h"
#import "UIButton+Maker.h"
#import "UIView+FrameValues.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"

@implementation AlertBox

@synthesize messageLabel, button1, button2, backgroundBox;
extern BOOL NSLogOn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.frame = frame;
		plog(@"alert box created: %@", self);
    }
	self.userInteractionEnabled = YES;
    return self;
}

-(void)fillAlertBox:(NSString *)message button1Text:(NSString *)button1Text button2Text:(NSString *)button2Text action1:(SEL)action1 action2:(SEL)action2 calledFrom:(NSObject *)callingViewController opacity:(float)opacity centreText:(BOOL)centreText {
	float boxWidth = self.frame.size.width;
	float boxHeight = self.frame.size.height;
	//	[self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.85]];
	backgroundBox = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, boxWidth, boxHeight)];
//	backgroundBox.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:0.75];
	backgroundBox.backgroundColor = [UIColor colorWithWhite:1.0 alpha:opacity];
	CALayer *layer = backgroundBox.layer;
//    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 7.0f;
    layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.75].CGColor;
	[self addSubview:backgroundBox];
	messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(layer.borderWidth * 2, 0, boxWidth - layer.borderWidth * 4, button1Text ? boxHeight * 0.6 : boxHeight)];
	messageLabel.text = message;
//	messageLabel.textColor = [UIColor whiteColor];
	messageLabel.textColor = [UIColor blackColor];
	messageLabel.backgroundColor = [UIColor clearColor];
//	messageLabel.layer.cornerRadius = 12.0f;
	[messageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]];
	messageLabel.textAlignment = centreText ? NSTextAlignmentCenter : NSTextAlignmentLeft;
	messageLabel.numberOfLines = 0;
	[self addSubview:messageLabel];
	if (button1Text) {
		button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1 = [UIButton makeButton:button1Text addShine:YES dimensions:CGRectMake(0, 0, boxWidth, boxHeight * 0.3)];
		[button1 addTarget:callingViewController action:action1 forControlEvents:UIControlEventTouchUpInside];
		if (button2Text) {
			button2 = [UIButton buttonWithType:UIButtonTypeCustom];
			button2 = [UIButton makeButton:button2Text addShine:YES dimensions:CGRectMake(boxWidth * 0.525, boxHeight * 0.6, boxWidth * 0.425, boxHeight * 0.3)];
			[button2 addTarget:callingViewController action:action2 forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button2];
			button1.frame = CGRectMake(0.05 * boxWidth, boxHeight * 0.6, boxWidth * 0.425, boxHeight * 0.3);
		} else {
			button1.frame = CGRectMake(boxWidth * 0.3, boxHeight * 0.6, boxWidth * 0.4, boxHeight * 0.3);
		}
		[self addSubview:button1];
	}
}

-(void) addBoxToView:(UIView *)view withOrientation:(BOOL)cachedOrientationIsLandscape {
	[view addSubview:self];
	[self bringSubviewToFront:view];
	CGRect boxFrame = self.frame;
	CGRect viewFrame = view.frame;
	float x = (viewFrame.size.width - boxFrame.size.width) * 0.5;
	float y = (viewFrame.size.height - boxFrame.size.height) * 0.3;
	self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
//	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//	float rotationValue = orientation == UIDeviceOrientationLandscapeRight ? - M_PI/2 : M_PI/2;
//	if (cachedOrientationIsLandscape) self.transform = CGAffineTransformMakeRotation(rotationValue);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
