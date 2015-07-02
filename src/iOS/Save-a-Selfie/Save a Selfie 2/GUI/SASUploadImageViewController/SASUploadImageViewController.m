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
#import "SASAlertView.h"
#import "SASUploader.h"


@interface SASUploadImageViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet SASImageView *sasImageView;
@property (weak, nonatomic) IBOutlet SASMapView *sasMapView;
@property (strong, nonatomic) SASAnnotation *sasAnnotation;

@property (weak, nonatomic) IBOutlet UIButton *defibrillatorButton;
@property (weak, nonatomic) IBOutlet UIButton *lifeRingButton;
@property (weak, nonatomic) IBOutlet UIButton *firstAidKitButton;
@property (weak, nonatomic) IBOutlet UIButton *fireHydrantButton;
@property (weak, nonatomic) IBOutlet UILabel *selectDeviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property(strong, nonatomic) IBOutlet UITextView *deviceDescriptionTextView;

@property (strong, nonatomic) NSMutableArray *deviceButtonsArray;
@property (nonatomic, assign) BOOL deviceHasBeenSelected;


@end

@implementation SASUploadImageViewController

@synthesize sasImageView;
@synthesize sasUploadObject;
@synthesize sasMapView;
@synthesize sasAnnotation;

@synthesize defibrillatorButton;
@synthesize lifeRingButton;
@synthesize firstAidKitButton;
@synthesize fireHydrantButton;
@synthesize deviceButtonsArray;
@synthesize selectDeviceLabel;
@synthesize doneButton;
@synthesize deviceHasBeenSelected;



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissKeyboard];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.sasAnnotation == nil) {
        self.sasAnnotation = [[SASAnnotation alloc] init];
    }
    
    self.sasAnnotation.coordinate = self.sasUploadObject.coordinates;
    
    self.sasMapView.sasAnnotationImage = DefaultAnnotationImage;
    [self.sasMapView showAnnotation:self.sasAnnotation andZoom:YES animated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    self.doneButton.hidden = YES;
    self.sasImageView.image = self.sasUploadObject.image;
    
    [UIFont increaseCharacterSpacingForLabel:self.selectDeviceLabel byAmount:2.0];
    [UIFont increaseCharacterSpacingForLabel:self.doneButton.titleLabel byAmount:1.0];
    
    
    self.deviceDescriptionTextView.delegate = self;
    
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
}


- (IBAction)deviceSelected:(UIButton*)sender {
    
    if (sender == self.defibrillatorButton) {
        [self.defibrillatorButton setImage:[UIImage imageNamed:@"DefibrillatorSelected"] forState:UIControlStateNormal];
        self.deviceHasBeenSelected = YES;
    }
    else if (sender == self.lifeRingButton) {
        [self.lifeRingButton setImage: [UIImage imageNamed:@"LifeRingSelected"] forState:UIControlStateNormal];
        self.deviceHasBeenSelected = YES;
    }
    else if (sender == self.firstAidKitButton) {
        [self.firstAidKitButton setImage: [UIImage imageNamed:@"FirstAidKitSelected"] forState:UIControlStateNormal];
        self.deviceHasBeenSelected = YES;
    }
    else if (sender == self.fireHydrantButton) {
        [self.fireHydrantButton setImage: [UIImage imageNamed:@"FireHydrantSelected"] forState:UIControlStateNormal];
        self.deviceHasBeenSelected = YES;
    }
    
    self.doneButton.hidden = NO;
}



- (BOOL) makeAppropriateChecksBeforeUploading {
    if ([self.deviceDescriptionTextView.text isEqualToString:@"Add Location Information"] ||
        [self.deviceDescriptionTextView.text isEqualToString:@""]) {
        
        
        SASAlertView *sasAlertView = [[SASAlertView alloc] initWithTitle:@"ALERT"
                                                                 message:@"Please add description for this upload."
                                                          andButtonTitle:@"Ok"
                                                              Withtarget:self
                                                                  action:nil];
        [sasAlertView animateIntoView:self.view];
        return NO;
    } else if (!deviceHasBeenSelected) {
        return NO;
    }
    else {
        return  YES;
    }
}





#pragma mark Upload Routine
- (IBAction)beginUploadRoutine:(id)sender {
    
    [self.sasUploadObject setTimeStamp: [SASUtilities getCurrentTimeStamp]];
    
    if([self makeAppropriateChecksBeforeUploading]) {
        SASUploader *sasUploader = [[SASUploader alloc] init];
        
        [sasUploader uploadObject:self.sasUploadObject];
    }
}


- (void) dismissKeyboard {
    [self.deviceDescriptionTextView resignFirstResponder];
}


#pragma mark UITextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([self.deviceDescriptionTextView.text isEqualToString:@"Add Location Information"]) {
        self.deviceDescriptionTextView.text = @"";
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    self.sasUploadObject.description = textView.text;
    NSLog(@"%@", self.sasUploadObject.description);
}




#pragma mark Cancel upload
- (void) dismissSASUploadImageViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
