//
//  SASUploadImageViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploadImageViewController.h"
#import "SASImageView.h"
#import "SASUtilities.h"
#import "SASAnnotation.h"
#import "UIFont+SASFont.h"
#import "Screen.h"
#import "SASBarButtonItem.h"


@interface SASUploadImageViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet SASImageView *sasImageView;
@property (strong, nonatomic) SASAnnotation *sasAnnotation;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *defibrillatorButton;
@property (weak, nonatomic) IBOutlet UIButton *lifeRingButton;
@property (weak, nonatomic) IBOutlet UIButton *firstAidKitButton;
@property (weak, nonatomic) IBOutlet UIButton *fireHydrantButton;
@property (weak, nonatomic) IBOutlet UILabel *selectDeviceLabel;

@property (strong, nonatomic) NSMutableArray *deviceButtonsArray;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *backArrowButton;
@property(strong, nonatomic) UITextView *deviceDescription;

@property(nonatomic, assign) BOOL canSlideLeft;
@property(nonatomic, assign) BOOL canSlideRight;


@property(nonatomic, strong) SASBarButtonItem *dismissKeyBoardBarButtonItem;


@end

@implementation SASUploadImageViewController

@synthesize sasImageView;
@synthesize sasUploadObject;
@synthesize blurredImageView;
@synthesize sasMapView;
@synthesize sasAnnotation;

@synthesize defibrillatorButton;
@synthesize lifeRingButton;
@synthesize firstAidKitButton;
@synthesize fireHydrantButton;
@synthesize deviceButtonsArray;
@synthesize selectDeviceLabel;
@synthesize nextButton;
@synthesize backArrowButton;
@synthesize dismissKeyBoardBarButtonItem;

@synthesize canSlideLeft;
@synthesize canSlideRight;


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.sasAnnotation == nil) {
        self.sasAnnotation = [[SASAnnotation alloc] init];
    }
    
    self.sasAnnotation.coordinate = [sasMapView currentUserLocation];
    
    self.sasMapView.sasAnnotationImage = DefaultAnnotationImage;
    [self.sasMapView showAnnotation:self.sasAnnotation andZoom:YES animated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    
    self.nextButton.hidden = YES;
    self.backArrowButton.hidden = YES;
    self.sasImageView.image = self.sasUploadObject.image;
    self.blurredImageView.image = self.sasUploadObject.image;
    
    self.blurredImageView.contentMode = UIViewContentModeScaleToFill;
    [SASUtilities addSASBlurToView:self.blurredImageView];
    

    [UIFont increaseCharacterSpacingForLabel:self.selectDeviceLabel byAmount:2.0];
    [UIFont increaseCharacterSpacingForLabel:self.nextButton.titleLabel byAmount:1.0];
    
    
    SASBarButtonItem *cancelBarButtonItem = [[SASBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(dismissSASUploadImageViewController)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    self.navigationController.navigationBar.topItem.title = @"Upload";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f] }];
    
    
    if (self.deviceButtonsArray == nil) {
        self.deviceButtonsArray = [[NSMutableArray alloc] initWithObjects:defibrillatorButton,
                                   lifeRingButton,
                                   firstAidKitButton,
                                   fireHydrantButton,
                                   nil];
    }
    
    
    
    if(self.deviceDescription == nil) {
        self.deviceDescription = [[UITextView alloc] initWithFrame:CGRectMake([Screen width], 64, [Screen width], [Screen height] - 111)];
        self.deviceDescription.font = [UIFont sasFontWithSize:15];
        self.deviceDescription.delegate = self;
        self.deviceDescription.layer.cornerRadius = 8.0;
        self.deviceDescription.backgroundColor = [UIColor colorWithRed:0.913 green:0.913 blue:0.913 alpha:1.0];
        self.deviceDescription.text = @"Add text";
        [self.view addSubview:self.deviceDescription];
    }
    
    
    
}

- (IBAction)deviceSelected:(UIButton*)sender {
    
    
    for (UIButton *deviceButton in self.deviceButtonsArray) {
        deviceButton.selected = NO;
    }

    if (sender == self.defibrillatorButton) {
        [self.defibrillatorButton setImage:[UIImage imageNamed:@"DefibrillatorSelected"] forState:UIControlStateNormal];
        sender.selected = YES;
    }
    else if (sender == self.lifeRingButton) {
        [self.lifeRingButton setImage: [UIImage imageNamed:@"LifeRingSelected"] forState:UIControlStateNormal];
        sender.selected = YES;
    }
    else if (sender == self.firstAidKitButton) {
        [self.firstAidKitButton setImage: [UIImage imageNamed:@"FirstAidKitSelected"] forState:UIControlStateNormal];
        sender.selected = YES;
    }
    else if (sender == self.fireHydrantButton) {
        [self.fireHydrantButton setImage: [UIImage imageNamed:@"FireHydrantSelected"] forState:UIControlStateNormal];
        sender.selected = YES;
    }
    
    self.nextButton.hidden = NO;
    self.canSlideLeft = YES;

}



- (IBAction)nextButtonPress:(id)sender {
    [self slideLeft:nil];
}

- (IBAction)backButtonPress:(id)sender {
    [self slideRight:nil];
}



- (void) slideLeft:(void(^)(BOOL finished)) completion {
    
    if(self.canSlideLeft ) {
        
        self.canSlideLeft = NO;
        
        for (UIView* subview in self.view.subviews) {
            
            if (subview != self.nextButton) {
                [UIView animateWithDuration:1.0
                                      delay:0.1
                     usingSpringWithDamping:0.5
                      initialSpringVelocity:0.3
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{subview.frame = CGRectOffset(subview.frame,-[Screen width] , 0);}
                                 completion:nil];
            }
        }
        [self.nextButton setTitle:@"DONE" forState:UIControlStateNormal];
        self.backArrowButton.hidden = NO;
    }
    
}

- (void) slideRight:(void(^)(BOOL finished)) completion {
    
    for(UIView* subview in self.view.subviews) {
        if(subview != self.nextButton) {
            [UIView animateWithDuration:1.0
                                  delay:0.1
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:0.3
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{subview.frame = CGRectOffset(subview.frame,subview.frame.origin.x * 2 , 0);}
                             completion:nil];
        }
    }
    [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    self.backArrowButton.hidden = YES;
}





- (void) dismissKeyboard {
    [self.deviceDescription resignFirstResponder];
    self.dismissKeyBoardBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}




#pragma UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {

    self.dismissKeyBoardBarButtonItem = [[SASBarButtonItem alloc] initWithTitle:@"Hide Keyboard" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
    
    self.navigationItem.rightBarButtonItem = self.dismissKeyBoardBarButtonItem;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    self.sasUploadObject.description = textView.text;
}




#pragma Cancel upload
- (void) dismissSASUploadImageViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
