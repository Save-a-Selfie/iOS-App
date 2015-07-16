//
//  UIView+NibInitializer.h
//  Save a Selfie 2
//
// from http://stackoverflow.com/questions/863321/how-to-load-a-uiview-using-a-nib-file-created-with-interface-builder
//

#import <UIKit/UIKit.h>

@interface UIView (NibInitializer)
- (instancetype)initWithNibNamed:(NSString *)nibNameOrNil;
@end
