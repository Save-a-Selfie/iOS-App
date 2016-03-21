//
//  SASSponsorCardController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 13/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASSponsorCardManager.h"

@implementation SASSponsorCardManager

+ (NSArray *) allCards {
  
  SASSponsorCardView *socialInno = [[SASSponsorCardView alloc] init];
  socialInno.titleLabel.text = @"Social Innovation Fund";
  socialInno.imageView.image = [UIImage imageNamed:@"social_inno"];
  [socialInno.button setTitle:@"Visit our website" forState:UIControlStateNormal];
  socialInno.info = @"Sustaining great ideas.";
  socialInno.website = @"http://www.socialinnovation.ie";
  
  SASSponsorCardView *saveSelfie = [[SASSponsorCardView alloc] init];
  saveSelfie.titleLabel.text = @"Save A Selfie";
  saveSelfie.imageView.image = [UIImage imageNamed:@"SaveASelfieLogo"];
  [saveSelfie.button setTitle:@"Visit our website" forState:UIControlStateNormal];
  saveSelfie.info = @"Your smile can save a life!";
  saveSelfie.website = @"http://www.saveaselfie.org";
  
  SASSponsorCardView *orderOfMalta = [[SASSponsorCardView alloc] init];
  orderOfMalta.titleLabel.text = @"Order of Malta";
  orderOfMalta.imageView.image = [UIImage imageNamed:@"Order of Malta 300"];
  [orderOfMalta.button setTitle:@"Visit our website" forState:UIControlStateNormal];
  orderOfMalta.info = @"Saving lives, Touching lives, Changing lives!";
  orderOfMalta.website = @"http://www.orderofmaltaireland.org/";
  
  
  SASSponsorCardView *fireBrigade = [[SASSponsorCardView alloc] init];
  fireBrigade.titleLabel.text = @"Dublin Fire Brigade";
  fireBrigade.imageView.image = [UIImage imageNamed:@"dublin fire brigade 300"];
  [fireBrigade.button setTitle:@"Visit our website" forState:UIControlStateNormal];
  fireBrigade.info = @"Serving Dublin for over 150 years!";
  fireBrigade.website = @"http://www.dfbexternaltraining.ie/";
  
  
  SASSponsorCardView *codeForIreland = [[SASSponsorCardView alloc] init];
  codeForIreland.titleLabel.text = @"Code For Ireland";
  codeForIreland.imageView.image = [UIImage imageNamed:@"Code for ireland logo"];
  [codeForIreland.button setTitle:@"Visit our website" forState:UIControlStateNormal];
  codeForIreland.info = @"Building, creating, empowering through technology!";
  codeForIreland.website = @"http://codeforireland.com/";
  
  SASSponsorCardView *adamsGift = [[SASSponsorCardView alloc] init];
  adamsGift.titleLabel.text = @"Adams Gift";
  adamsGift.imageView.image = [UIImage imageNamed:@"AdamsGift"];
  [adamsGift.button setTitle:@"Visit us on Facebook " forState:UIControlStateNormal];
  adamsGift.info = @"Saving lives through awareness and education!";
  adamsGift.website = @"https://www.facebook.com/pages/Adams-Gift/334232113442348?fref=ts";
  
  
  
  
  
  NSArray *cardViews = [[NSArray alloc] initWithObjects:
                        socialInno,
                        saveSelfie,
                        orderOfMalta,
                        fireBrigade,
                        codeForIreland,
                        adamsGift,
                        nil];
  return cardViews;
  
}


+ (NSUInteger)sponsorAmount {
  return 6;
}


@end
