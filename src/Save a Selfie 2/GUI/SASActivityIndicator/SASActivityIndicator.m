//
//  SASActivityIndicator.m
//  SASActivityIndicator
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASActivityIndicator.h"
#import "SASColour.h"
#import "UIView+NibInitializer.h"

@interface SASActivityIndicator()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SASActivityIndicator



- (instancetype)initWithMessage:(NSString*) aMessage {
    if (self = [super init]) {
        
        self = [self initWithNibNamed:@"SASActivityIndicatorView"];
        
        _message.text = aMessage;
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor grayColor];
        self.layer.opacity = 0.8;
    }
    return self;
}


- (void) startAnimating {
    [self.activityIndicator startAnimating];
}

- (void) stopAnimating {
    [self.activityIndicator stopAnimating];
}

@end
