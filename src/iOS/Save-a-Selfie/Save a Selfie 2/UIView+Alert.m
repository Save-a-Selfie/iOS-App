//
//  UIView+Alert.m
//  Save a Selfie
//

#import "UIView+Alert.h"

@implementation UIView (Alert)

-(AlertBox *)makeAlert {
    return [self makeAlertWithHeight:90];
}

-(AlertBox *)makeAlertWithHeight:(float)height {
//    if (alert) { [self removeAlert]; }
    [[NSBundle mainBundle] loadNibNamed:@"AlertBox" owner:self options:nil];
    AlertBox *alert = [[AlertBox alloc] initWithFrame:CGRectMake(20, 150, 260, height)];
    alert.center = self.center;
    return alert;
}

-(AlertBox *)permissionsProblem:(NSString *)message {
    AlertBox *permissionsBox = [self makeAlertWithHeight:200];
    [permissionsBox fillAlertBox:message button1Text:nil button2Text:nil action1:nil action2:nil calledFrom:self opacity:0.85 centreText:NO];
    permissionsBox.center = self.center;
    [permissionsBox addBoxToView:self withOrientation:0];
    return permissionsBox;
}

@end
