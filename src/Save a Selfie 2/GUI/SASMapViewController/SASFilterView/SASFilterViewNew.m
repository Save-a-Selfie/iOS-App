//
//  SASFilterViewNew.m
//  Save a Selfie
//
//  Created by Stephen Fox on 27/09/2015.
//  Copyright © 2015 Stephen Fox. All rights reserved.
//

#import "SASFilterViewNew.h"
#import "SASFilterViewButton.h"
#import "SASDevice.h"
#import "Screen.h"


@interface SASFilterViewNew () {
    CGFloat buttonSpacing;
}

@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (strong, nonatomic) NSMutableArray *unselectedItems;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (weak, nonatomic) SASMapView *referencedMapView;


@end



@implementation SASFilterViewNew


- (instancetype)initWithPosition:(CGPoint) position forMapView:(SASMapView *) mapView {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    

    self.frame = CGRectMake(position.x, position.y, 45, 245);
    _referencedMapView = mapView;
    
    self.layer.masksToBounds = NO;
    
    
    return self;
}



- (void) presentIntoView:(UIView *) view {
    
    buttonSpacing = 55;

    
    // Lazily Initialise all buttons.
    if(!self.buttons) {
        
        int buttonCapacity = 4;
        self.buttons = [[NSMutableArray alloc] initWithCapacity:4];
        
        for (int i = 0; i < buttonCapacity; i++) {
            
            printf("yeah");
            
            SASFilterButtonType buttonType = i; // use i to get Enum value.
            
            SASFilterViewButton *button = [[SASFilterViewButton alloc] initWithType:buttonType];
            button.frame = CGRectMake(0, self.frame.size.height - buttonSpacing, 45, 45);
            

            [self addSubview:button];
            [self.buttons addObject:button];

            buttonSpacing += 55;

        }
    }
    
    [view addSubview:self];
}


- (void) animateToView {
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
    
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 245);
                     }
                     completion:nil];
    
}



- (void) filterForDevice:(SASFilterViewButton *) sender {
}




#pragma mark - Helper methods.
- (UIImage *) imageForDevice:(SASDeviceType) type{
    return [SASDevice getDeviceImageForDeviceType:type];
}


- (UIImage *) unselectedImageForDevice: (SASDeviceType) type {
    return [SASDevice getUnselectedDeviceImageForDevice:type];
}



@end





