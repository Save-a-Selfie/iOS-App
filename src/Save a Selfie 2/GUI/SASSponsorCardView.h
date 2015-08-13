//
//  SASSponsorCardView.h
//  Save a Selfie
//
//  Created by Stephen Fox on 12/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASSponsorCardView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) NSString *website;

@end
