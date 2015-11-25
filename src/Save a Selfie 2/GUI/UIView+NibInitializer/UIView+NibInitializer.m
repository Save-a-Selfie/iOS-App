//
//  UIView+NibInitializer.m
//  Save a Selfie 2
//
//  from http://stackoverflow.com/questions/863321/how-to-load-a-uiview-using-a-nib-file-created-with-interface-builder
//

#import "UIView+NibInitializer.h"

@implementation UIView (NibInitializer)

- (instancetype)initWithNibNamed:(NSString *)nibNameOrNil {
    
    if (!nibNameOrNil) {
        nibNameOrNil = NSStringFromClass([self class]);
    }
    
    NSArray *viewsInNib = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil
                                                        owner:self
                                                      options:nil];
    for (id view in viewsInNib) {
        if ([view isKindOfClass:[self class]]) {
            self = view;
            break;
        }
    }
    return self;
}

@end
