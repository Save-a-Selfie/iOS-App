//
//  UIView+Alert.h
//  Save a Selfie
//

#import <UIKit/UIKit.h>
#import "AlertBox.h"

@interface UIView (Alert)
-(AlertBox *)makeAlert;
-(AlertBox *)makeAlertWithHeight:(float)height;
-(AlertBox *)permissionsProblem:(NSString *)message;
@end
