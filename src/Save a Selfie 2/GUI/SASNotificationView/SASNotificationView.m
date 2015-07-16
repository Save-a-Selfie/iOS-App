//
//  SASNotificationView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 10/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASNotificationView.h"
#import "UIView+NibInitializer.h"
#import "UIFont+SASFont.h"


@interface SASNotificationView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SASNotificationView

@synthesize title;
@synthesize image;

// IBOutlets
@synthesize titleLabel;
@synthesize imageView;


- (instancetype)init {
    if(self = [super init]) {
        self = [self initWithNibNamed:@"SASNotificationView"];
        self.layer.cornerRadius = 8.0;
        

    }
    return self;
}



- (void)setTitle:(NSString *) aTitle {
    self.titleLabel.text = aTitle;
    [UIFont increaseCharacterSpacingForLabel:self.titleLabel byAmount:2.0];

    
}

- (void)setImage:(UIImage *)aImage {
    self.imageView.image = aImage;
}



#pragma mark Animations
- (void) animateIntoView:(UIView *) view {
    
    self.alpha = 0.0f;
    self.center = view.center;
    [view addSubview:self];
    
    [UIView animateWithDuration:1.0
                     animations:^{self.alpha = 1.0f;}
                     completion:^(BOOL completed){
                         [UIView animateWithDuration:2.0
                                          animations:^{self.alpha = 0.0f;}
                                          completion:nil];}];
    
    
}


@end
