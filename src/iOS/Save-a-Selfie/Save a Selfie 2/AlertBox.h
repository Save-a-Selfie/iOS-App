//
//  AlertBox.h
//  Photoapp4it
//
//  Created by Peter FitzGerald on 23/05/2013.
//  Copyright (c) 2013 Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class AlertBox;
@interface AlertBox : UIView

@property (strong, nonatomic) IBOutlet UILabel *backgroundBox;
@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;

-(void)fillAlertBox:(NSString *)message button1Text:(NSString *)button1Text button2Text:(NSString *)button2Text action1:(SEL)action1 action2:(SEL)action2 calledFrom:(NSObject *)callingViewController opacity:(float)opacity centreText:(BOOL)centreText;

-(void) addBoxToView:(UIView *)view withOrientation:(BOOL)cachedOrientationIsLandscape;

@end
