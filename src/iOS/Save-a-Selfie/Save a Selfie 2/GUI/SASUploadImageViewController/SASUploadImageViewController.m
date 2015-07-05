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
#import "SASDeviceButton.h"
#import "SASUploadObjectValidator.h"
#import "SASGreyView.h"


@interface SASUploadImageViewController () <UITextViewDelegate, SASUploaderDelegate>

@property (strong, nonatomic) IBOutlet SASImageView *sasImageView;
@property (weak, nonatomic) IBOutlet SASMapView *sasMapView;
@property (strong, nonatomic) SASAnnotation *sasAnnotation;

@property (weak, nonatomic) IBOutlet SASDeviceButton *defibrillatorButton;
@property (weak, nonatomic) IBOutlet SASDeviceButton *lifeRingButton;
@property (weak, nonatomic) IBOutlet SASDeviceButton *firstAidKitButton;
@property (weak, nonatomic) IBOutlet SASDeviceButton *fireHydrantButton;
@property (weak, nonatomic) IBOutlet UILabel *selectDeviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property(strong, nonatomic) IBOutlet UITextView *deviceCaptionTextView;
@property(strong, nonatomic) SASGreyView *sasGreyView;

@property (strong, nonatomic) NSMutableArray *deviceButtonsArray;
@property (nonatomic, assign) BOOL deviceHasBeenSelected;

@property (strong, nonatomic) SASUploader *sasUploader;

@end

@implementation SASUploadImageViewController

@synthesize sasImageView;
@synthesize sasUploadObject;
@synthesize sasMapView;
@synthesize sasAnnotation;
@synthesize sasGreyView;

@synthesize defibrillatorButton;
@synthesize lifeRingButton;
@synthesize firstAidKitButton;
@synthesize fireHydrantButton;
@synthesize deviceButtonsArray;
@synthesize selectDeviceLabel;
@synthesize doneButton;
@synthesize deviceHasBeenSelected;

@synthesize sasUploader;



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissKeyboard];
}


- (void) dismissKeyboard {
    [self.deviceCaptionTextView resignFirstResponder];
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
    
    
    self.deviceCaptionTextView.delegate = self;
    self.deviceCaptionTextView.layer.cornerRadius = 2.0;
    
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
    
    self.defibrillatorButton.selectedImage = [UIImage imageNamed:@"DefibrillatorSelected"];
    self.defibrillatorButton.deviceType = Defibrillator;
    
    self.lifeRingButton.selectedImage = [UIImage imageNamed:@"LifeRingSelected"];
    self.lifeRingButton.deviceType = LifeRing;
    
    self.firstAidKitButton.selectedImage = [UIImage imageNamed:@"FirstAidKitSelected"];
    self.firstAidKitButton.deviceType = FirstAidKit;
    
    self.fireHydrantButton.selectedImage = [UIImage imageNamed:@"FireHydrantSelected"];
    self.fireHydrantButton.deviceType = FireHydrant;
    
    self.defibrillatorButton.unselectedImage = [UIImage imageNamed:@"DefibrillatorUnselected"];
    self.lifeRingButton.unselectedImage = [UIImage imageNamed:@"LifeRingUnselected"];
    self.firstAidKitButton.unselectedImage = [UIImage imageNamed:@"FirstAidKitUnselected"];
    self.fireHydrantButton.unselectedImage = [UIImage imageNamed:@"FireHydrantUnselected"];
    
}



- (IBAction)deviceSelected:(SASDeviceButton*) sender {
    
    for(SASDeviceButton* button in self.deviceButtonsArray) {
        [button deselect];
    }
    
    [sender select];
    
#pragma mark SASUploadObject associated Device. set here.
    self.sasUploadObject.associatedDevice.type = sender.deviceType;

    self.doneButton.hidden = NO;
}





#pragma mark Upload Routine
- (IBAction)beginUploadRoutine:(id)sender {
    
    
#pragma mark SASUploadObject timestamp set here.
    [self.sasUploadObject setTimeStamp: [SASUtilities getCurrentTimeStamp]];
    
    NSLog(@"%ld", (long)self.sasUploadObject.associatedDevice.type);
    NSLog(@"%@", self.sasUploadObject.caption);
    
    
    self.sasUploader = [[SASUploader alloc] initWithSASUploadObject:self.sasUploadObject];
    self.sasUploader.delegate = self;
    
    // Upload the object to the server.
    [self.sasUploader upload];
}



#pragma mark SASUploaderDelegate
- (void)sasUploaderDidFinishUploadWithSuccess:(SASUploader *)sasUploader {
    printf("Called");
    [self dismissSASUploadImageViewController];
}


- (void)sasUploader:(SASUploader *)sasUploader didFailWithError:(NSError *)error {
// TODO: Add error message.
}




#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([self.deviceCaptionTextView.text isEqualToString:@"Add Location Information"]) {
        self.deviceCaptionTextView.text = @"";
    }
    
    [self addGreyView];
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if([self.deviceCaptionTextView.text isEqualToString:@""]) {
        self.deviceCaptionTextView.text = @"Add Location Information";
    }
    
#pragma mark SASUploadObject.description set here.
    self.sasUploadObject.caption = textView.text;
    

    
    [self removeGreyView];
}


// Adds a SASGrey view which dims the background apart from `deviceCaptionTextView` &
// `sasImageView`.
- (void) addGreyView {
    if (self.sasGreyView == nil) {
        self.sasGreyView = [[SASGreyView alloc] initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
    }
    [self.sasGreyView animateIntoView:self.view];
    [self.view bringSubviewToFront:self.sasImageView];
    [self.view bringSubviewToFront:self.deviceCaptionTextView];
    
}

- (void) removeGreyView {
    [self.sasGreyView animateOutOfParentView];
}

- (void) dismissSASUploadImageViewController {
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
