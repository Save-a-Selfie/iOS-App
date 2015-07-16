//
//  PopupImage.h
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 28/12/2014.
//  Copyright (c) 2014 Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PopupImage : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *background;
@property (strong, nonatomic) IBOutlet UIButton *xButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)closePopup:(id)sender;

@end
