//
//  SASActivityIndicator.h
//  SASActivityIndicator
//
//  Created by Stephen Fox on 04/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASActivityIndicator : UIView

@property (weak, nonatomic) IBOutlet UILabel *message;

- (void) startAnimating;
- (void) stopAnimating;


// initWIthImage sets the message that will acompany the spinner.
- (instancetype)initWithMessage:(NSString*) aMessage;

@end
