//
//  EmergencyObjects.m
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 02/11/2014.
//  Copyright (c) 2014 Peter FitzGerald. All rights reserved.
//

#import "EmergencyObjects.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"
#import "UIView+WidthXY.h"
#import "UIButton+VerticalLayout.h"
#import "UIButton+Maker.h"

@implementation EmergencyObjects
NSArray *labelPointer;
NSArray *buttonPointer;
UIButton *uploadButton, *cancelButton;
extern NSString *const objectChosen;
extern int chosenObject;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)EmergencyObjectsViewLoaded {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float screenWidth = screenRect.size.width;
    float buttonHeight = 100.0;
    float buttonHeight2 = buttonHeight * 0.35;
    float buttonWidth = screenWidth * 0.5, buttonWidth2 = screenWidth * 0.25;
    labelPointer = [[NSArray alloc] initWithObjects:_background1, _background2, _background3, _background4, nil];
    buttonPointer = [[NSArray alloc] initWithObjects:_EmObj1, _EmObj2, _EmObj3, _EmObj4, nil];
    float topGap = 20; float padding = 5; // padding is for between button image and button label below image
    plog(@"button width: %f, screen width: %f", buttonWidth, screenWidth);

    // centre button text in button
//    for (int i = 0; i < buttonPointer.count; i++) {
    for (UIButton *b in buttonPointer) {
        [b centerVerticallyWithPadding:padding]; [b setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }

    // button Y values initially set off screen – will be moved below
    _background1.frame = CGRectMake(0, -buttonHeight, buttonWidth, buttonHeight);
    _EmObj1.frame = CGRectMake(buttonWidth2 - [self halfButtonTextWidth:_EmObj1], -buttonHeight, _EmObj1.titleLabel.frame.size.width, buttonHeight);
    _background2.frame = CGRectMake(buttonWidth, -buttonHeight, buttonWidth, buttonHeight);

    _EmObj2.frame = CGRectMake(buttonWidth + buttonWidth2 - [self halfButtonTextWidth:_EmObj2], -buttonHeight, _EmObj2.titleLabel.frame.size.width, buttonHeight);
    _background3.frame = CGRectMake(0, -buttonHeight, buttonWidth, buttonHeight);

    _EmObj3.frame = CGRectMake(buttonWidth2 - [self halfButtonTextWidth:_EmObj3], -buttonHeight, _EmObj3.titleLabel.frame.size.width, buttonHeight);
    _background4.frame = CGRectMake(buttonWidth, -buttonHeight, buttonWidth, buttonHeight);

    _EmObj4.frame = CGRectMake(buttonWidth + buttonWidth2 - [self halfButtonTextWidth:_EmObj4], -buttonHeight, _EmObj4.titleLabel.frame.size.width, buttonHeight);
    _background1.text = @""; _background2.text = @""; _background3.text = @""; _background4.text = @"";

//    UILabel *objectTypeLabel= [[UILabel alloc] initWithFrame:CGRectMake(20, -buttonHeight, buttonWidth * 1.5 - 20, buttonHeight * 0.5)];
//    objectTypeLabel.textColor = [UIColor blueColor];
//    objectTypeLabel.text = @"Which is in the photo?";
//    [self addSubview:objectTypeLabel];
    
    uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadButton = [UIButton makeButton:@"Upload photo" addShine:NO dimensions:CGRectMake(0, 0, buttonWidth * 0.75, buttonHeight * 0.3)];
    uploadButton.enabled = NO;
    [uploadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    uploadButton.frame = CGRectMake((buttonWidth - uploadButton.frame.size.width) * 0.65, -buttonHeight, buttonWidth * 0.75, buttonHeight * 0.3);
    [uploadButton addTarget:self action:@selector(uploadPhoto) forControlEvents:UIControlEventTouchUpInside];

    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton = [UIButton makeButton:@"Cancel" addShine:NO dimensions:CGRectMake(0, 0, buttonWidth * 0.55, buttonHeight * 0.3)];
    cancelButton.enabled = YES;
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(uploadButton.frame.origin.x + uploadButton.frame.size.width + 20, -buttonHeight, buttonWidth * 0.55, buttonHeight * 0.3);
    [cancelButton addTarget:self action:@selector(cancelUpload) forControlEvents:UIControlEventTouchUpInside];
    
//    _uploadButton.frame = CGRectMake((buttonWidth - _uploadButton.frame.size.width) * 0.5, -buttonHeight, buttonWidth, buttonHeight * 0.5);
//    _uploadButton.enabled = NO;
//    _uploadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_uploadButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    self.frame = CGRectMake(0, topGap, screenWidth, buttonHeight * 2.5 + 20);
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.85];
    [self moveObject:-buttonHeight * 3 overTimePeriod:0.5];
    [self moveObject:topGap overTimePeriod:1.0];
    [_background1 moveObject:topGap overTimePeriod:1.0];
    [_EmObj1 moveObject:topGap + (buttonHeight2 - [self buttonTotalHeight:_EmObj1 withPadding:padding] * 0.5) overTimePeriod:0.5];
    [_background2 moveObject:topGap overTimePeriod:1.0];
    [_EmObj2 moveObject:topGap + (buttonHeight2 - [self buttonTotalHeight:_EmObj2 withPadding:padding] * 0.5) overTimePeriod:0.5];
    [_background3 moveObject:buttonHeight + topGap overTimePeriod:1.0];
    [_EmObj3 moveObject:buttonHeight + topGap + (buttonHeight2 - [self buttonTotalHeight:_EmObj3 withPadding:padding] * 0.5) overTimePeriod:0.5];
    [_background4 moveObject:buttonHeight + topGap overTimePeriod:1.0];
    [_EmObj4 moveObject:buttonHeight + topGap + (buttonHeight2 - [self buttonTotalHeight:_EmObj4 withPadding:padding] * 0.5) overTimePeriod:0.5];
//    [_uploadButton sizeToFit];
    [self addSubview:uploadButton];
    [self addSubview:cancelButton];
    [uploadButton moveObject:buttonHeight * 2 + topGap overTimePeriod:0.75];
    [cancelButton moveObject:buttonHeight * 2 + topGap overTimePeriod:0.75];
}

-(float)buttonTotalHeight:(UIButton *)button withPadding:(float)padding {
    return button.imageView.frame.size.height + button.titleLabel.frame.size.height + padding;
}

-(float)halfButtonTextWidth:(UIButton *)button {
    return button.titleLabel.frame.size.width * 0.5;
}

- (IBAction)uploadPhoto {
    [[NSNotificationCenter defaultCenter] postNotificationName:objectChosen object:nil];
}

- (IBAction)cancelUpload {
    plog(@"cancelled!");
    chosenObject = -1;
    [[NSNotificationCenter defaultCenter] postNotificationName:objectChosen object:nil];
}

- (IBAction)EmObjTapped:(id)sender {
    for (UILabel *l in labelPointer) [l setBackgroundColor:[UIColor clearColor]];
    for (UIButton *b in buttonPointer)[b setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    UIButton *button = (UIButton *)sender;
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [(UILabel *)labelPointer[button.tag] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.125]];
    uploadButton.enabled = YES;
    [uploadButton setTitleColor:[UIColor colorWithRed:0.25 green:1 blue:0.25 alpha:1] forState:UIControlStateNormal];
    chosenObject = button.tag;
    [button bounceObject:20];
}

@end
