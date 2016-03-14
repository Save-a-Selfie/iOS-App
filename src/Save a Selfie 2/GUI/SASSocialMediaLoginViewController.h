//
//  SASFacebookLoginViewController.h
//  Save a Selfie
//
//  Created by Stephen Fox on 28/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@interface SASSocialMediaLoginViewController : UIViewController


/**
 Adds all the respective social media buttons to the 
 view controller's view.*/
- (instancetype) initWithSocialMediaButtons:(NSArray*) buttons;



@end
