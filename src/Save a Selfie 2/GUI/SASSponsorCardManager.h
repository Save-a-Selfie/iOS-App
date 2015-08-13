//
//  SASSponsorCardController.h
//  Save a Selfie
//
//  Created by Stephen Fox on 13/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASSponsorCardView.h"

/**
 Holds and manages all the information for all the sponsors
 of the app. This class just acts as a container for the sponsor information.
 */
@interface SASSponsorCardManager : UIView

/**
 Returns an array of `SASSponsorCardView`'s. Each sponsorCardView
 will have all the relevant details attached to the view, like the 
 sponsor image, name etc.
 
 Note the array is ordered as follows:
 0 - Dublin fire Brigade.
 1 - Adams Gift
 3 - Code for Ireland
 */
+ (NSArray *) allCards;


/**
 The numer of sponsor for the app.
 */
+ (NSUInteger) sponsorAmount;
@end
