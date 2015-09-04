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
#import "FXAlert.h"
#import "SASUploader.h"
#import "SASDeviceButton.h"
#import "SASGreyView.h"
#import "SASUtilities.h"
#import "SASActivityIndicator.h"
#import "ExtendNSLogFunctionality.h"
#import "UIView+NibInitializer.h"
#import "EULAViewController.h"
#import "SystemVersion.h"

#import "EULAViewController.h"
#import "SASActivityIndicator.h"
#import "ExtendNSLogFunctionality.h"
#import "UIView+NibInitializer.h"



@interface SASUploadImageViewController () <UITextViewDelegate, SASUploaderDelegate, EULADelegate>

@property (strong, nonatomic) IBOutlet SASImageView *sasImageView;
@property (weak, nonatomic) IBOutlet SASMapView *sasMapView;
@property (strong, nonatomic) SASAnnotation *sasAnnotation;

@property (weak, nonatomic) IBOutlet SASDeviceButton *defibrillatorButton;
@property (weak, nonatomic) IBOutlet SASDeviceButton *lifeRingButton;
@property (weak, nonatomic) IBOutlet SASDeviceButton *firstAidKitButton;
@property (weak, nonatomic) IBOutlet SASDeviceButton *fireHydrantButton;

@property (weak, nonatomic) IBOutlet UILabel *selectDeviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITextView *deviceCaptionTextView;

@property (strong, nonatomic) SASGreyView *sasGreyView;
@property (strong, nonatomic) SASActivityIndicator *sasActivityIndicator;

@property (strong, nonatomic) NSMutableArray *deviceButtonsArray;
@property (nonatomic, assign) BOOL deviceHasBeenSelected;

@property (strong, nonatomic) SASUploader *sasUploader;
@property (strong, nonatomic) EULAViewController * eulaViewController;
@property (strong, nonatomic) SASBarButtonItem *doneBarButtonItem;

@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) UIView* updateView;
@end

@implementation SASUploadImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f]}];
    
    [self displayUpdateInformation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
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
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(updateAnnotationOnMapView)];
    [self.sasMapView addGestureRecognizer:self.longPress];
    

    self.sasAnnotation.coordinate = self.sasUploadObject.coordinates;
    
    self.sasMapView.sasAnnotationImage = SASAnnotationImageDefault;
    [self.sasMapView showAnnotation:self.sasAnnotation andZoom:YES animated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.sasImageView.canShowFullSizePreview = NO;
    self.sasImageView.contentMode = UIViewContentModeScaleToFill;
    self.sasImageView.image = self.sasUploadObject.image;

    [UIFont increaseCharacterSpacingForLabel:self.selectDeviceLabel byAmount:2.0];
    [UIFont increaseCharacterSpacingForLabel:self.doneButton.titleLabel byAmount:1.0];
    
    
    self.deviceCaptionTextView.delegate = self;
    self.deviceCaptionTextView.layer.cornerRadius = 2.0;
    
    SASBarButtonItem *cancelBarButtonItem = [[SASBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    self.navigationController.navigationBar.topItem.title = @"Upload";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0f] }];
    
    
    if (self.deviceButtonsArray == nil) {
        self.deviceButtonsArray = [[NSMutableArray alloc] initWithObjects:self.defibrillatorButton,
                                   self.lifeRingButton,
                                   self.firstAidKitButton,
                                   self.fireHydrantButton,
                                   nil];
    }
    
    self.defibrillatorButton.selectedImage = [UIImage imageNamed:@"DefibrillatorSelected"];
    self.defibrillatorButton.deviceType = SASDeviceTypeDefibrillator;
    
    self.lifeRingButton.selectedImage = [UIImage imageNamed:@"LifeRingSelected"];
    self.lifeRingButton.deviceType = SASDeviceTypeLifeRing;
    
    self.firstAidKitButton.selectedImage = [UIImage imageNamed:@"FirstAidKitSelected"];
    self.firstAidKitButton.deviceType = SASDeviceTypeFirstAidKit;
    
    self.fireHydrantButton.selectedImage = [UIImage imageNamed:@"FireHydrantSelected"];
    self.fireHydrantButton.deviceType = SASDeviceTypeFireHydrant;
    
    self.defibrillatorButton.unselectedImage = [UIImage imageNamed:@"DefibrillatorUnselected"];
    self.lifeRingButton.unselectedImage = [UIImage imageNamed:@"LifeRingUnselected"];
    self.firstAidKitButton.unselectedImage = [UIImage imageNamed:@"FirstAidKitUnselected"];
    self.fireHydrantButton.unselectedImage = [UIImage imageNamed:@"FireHydrantUnselected"];
    
}

- (void) cancel {
    [self dismissSASUploadImageViewControllerWithResponse:SASUploadControllerResponseCancelled];
}



- (IBAction)deviceSelected:(SASDeviceButton*) sender {

    [self deselectDeviceButtons];
    
    [sender select];
    
    #pragma mark SASUploadObject associated Device. set here.
    self.sasUploadObject.associatedDevice.type = sender.deviceType;

    self.doneButton.hidden = NO;
}



// 'Deselects' a button by putting the image of the button back
// to the default image when the button was not selected;
- (void) deselectDeviceButtons {
    for (SASDeviceButton* button in self.deviceButtonsArray) {
        [button deselect];
    }
}


- (void) selectDeviceButton:(SASDeviceButton *) button {
    [button select];
}






- (void) updateAnnotationOnMapView {
    if(self.longPress.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [self.longPress locationInView:self.sasMapView];
    CLLocationCoordinate2D location = [self.sasMapView convertPoint:touchPoint toCoordinateFromView:self.sasMapView];
    

    self.sasAnnotation.coordinate = location;
    self.sasUploadObject.coordinates = self.sasAnnotation.coordinate;

    [self.sasMapView showAnnotation:self.sasAnnotation andZoom:NO animated:NO];
    
}






#pragma mark Upload Routine
- (IBAction)beginUploadRoutine:(id)sender {
    
    if (![self hasEULABeenAcepted]) {
        [self showAlertForEULAToBeAccepted];
    }
    else {
        
        #pragma mark SASUploadObject timestamp set here.
        self.sasUploadObject.timeStamp = [SASUtilities getCurrentTimeStamp];
        
        #pragma mark UUID set here.
        self.sasUploadObject.UUID = [NSUUID UUID].UUIDString;

        self.sasUploader = [[SASUploader alloc] initWithSASUploadObject:self.sasUploadObject];
        self.sasUploader.delegate = self;
        [self.sasUploader upload];
    }
}



#pragma mark <SASUploaderDelegate>
- (void)sasUploaderDidBeginUploading:(SASUploader *)sasUploader {
    
    // Activity Indicator
    self.sasActivityIndicator = [[SASActivityIndicator alloc] initWithMessage:@"Posting"];
    self.sasActivityIndicator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    [self.view addSubview:self.sasActivityIndicator];
    self.sasActivityIndicator.center = self.view.center;
    [self.sasActivityIndicator startAnimating];
    

    self.doneButton.enabled = NO;
    self.view.userInteractionEnabled = NO;
}



- (void)sasUploaderDidFinishUploadWithSuccess:(SASUploader *)sasUploader {
    [self dismissSASUploadImageViewControllerWithResponse:SASUploadControllerResponseUploaded];
    [self.sasActivityIndicator removeFromSuperview];
    [self.sasActivityIndicator stopAnimating];
    
}


- (void)sasUploader:(SASUploader *)sasUploader didFailWithError:(NSError *)error {

    self.view.userInteractionEnabled = YES;
    self.doneButton.enabled = YES;
    
    FXAlertController *uploadErrorAlert = [[FXAlertController alloc] initWithTitle:@"OOOPS!" message:@"There seemed to be a problem posting! Please check you're connected to Wifi/ Network and try again."];
    
    FXAlertButton *okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeCancel];
    [okButton setTitle:@"Ok" forState:UIControlStateNormal];
    
    [uploadErrorAlert addButton:okButton];
    
    [self presentViewController:uploadErrorAlert animated:YES completion:nil];
    
    [self.sasActivityIndicator removeFromSuperview];
    [self.sasActivityIndicator stopAnimating];
}



- (void)sasUploader:(SASUploadObject *)object invalidObjectWithResponse:(SASUploadInvalidObject)response {
    
    FXAlertController *invalidUploadObjectAlert = nil;
    FXAlertButton *okButton = nil;

     
    switch (response) {
        
        case SASUploadInvalidObjectCaption:
            invalidUploadObjectAlert = [[FXAlertController alloc] initWithTitle:@"OOOPS!"
                                                                        message:@"Please add a description for this post!"];
            okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeStandard];
            [okButton setTitle:@"Ok" forState:UIControlStateNormal];
            [invalidUploadObjectAlert addButton:okButton];
            [self presentViewController:invalidUploadObjectAlert animated:YES completion:nil];
            break;
            
            
        case SASUploadInvalidObjectDeviceType:
            invalidUploadObjectAlert = [[FXAlertController alloc] initWithTitle:@"OOOPS!"
                                                                        message:@"Please select a device for this post!"];
            okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeStandard];
            [okButton setTitle:@"Ok" forState:UIControlStateNormal];
            [invalidUploadObjectAlert addButton:okButton];
            [self presentViewController:invalidUploadObjectAlert animated:YES completion:nil];
            
            
        case SASUploadInvalidObjectCoordinates:
            invalidUploadObjectAlert = [[FXAlertController alloc] initWithTitle:@"OOOPS!"
                                                                        message:@"Cannot determine location. Please select the map and tap the location of the device"];
            okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeStandard];
            [okButton setTitle:@"Ok" forState:UIControlStateNormal];
            [invalidUploadObjectAlert addButton:okButton];
            [self presentViewController:invalidUploadObjectAlert animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}




#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (self.doneBarButtonItem == nil) {
        self.doneBarButtonItem = [[SASBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];
        self.navigationItem.rightBarButtonItem = self.doneBarButtonItem;
    }
    
    
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
    
    self.doneBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
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
    [self.view bringSubviewToFront:self.sasMapView];
}



- (void) dismissSASUploadImageViewControllerWithResponse:(SASUploadControllerResponse) response {
    
    // Call delegate.
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sasUploadImageViewControllerDidFinishUploading:withResponse:withObject:)]) {
        [self.delegate sasUploadImageViewControllerDidFinishUploading:self
                                                         withResponse:response
                                                           withObject:self.sasUploadObject];
            
    }
        
    [self dismissViewControllerAnimated:YES completion:nil];

}




#pragma Check the user has agreed to the End User Licence Agreement
- (BOOL) hasEULABeenAcepted {
    
    BOOL EULAAccepted = [[[NSUserDefaults standardUserDefaults] valueForKey:@"EULAAccepted"] isEqualToString:@"yes"];

   if (EULAAccepted) {
        return YES;
    } else {
        return NO;
    }
}



- (void) showAlertForEULAToBeAccepted {
    
    FXAlertController *eulaAlertPresent = [[FXAlertController alloc] initWithTitle:@"NOTE" message:@"Before posting, we need you to agree to the terms of use."];
    
    FXAlertButton *showMeButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeStandard];
    [showMeButton setTitle:@"Show me" forState:UIControlStateNormal];
    [showMeButton addTarget:self action:@selector(presentEULAViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [eulaAlertPresent addButton:showMeButton];
    
    [self presentViewController:eulaAlertPresent animated:YES completion:nil];
}



- (void) presentEULAViewController {
    
    self.eulaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EULAViewController"];
    
    [self presentViewController:self.eulaViewController animated:YES completion:nil];
    self.eulaViewController.delegate = self;
}



#pragma EULADelegate
- (void)eulaView:(EULAViewController *)view userHasRespondedWithResponse:(EULAResponse)response {
    

    [self.eulaViewController dismissViewControllerAnimated:YES completion:nil];

    if (response == EULAResponseAccepted) {
        [self.eulaViewController updateEULATable];
        // If its been accepted go ahead and upload.
        [self beginUploadRoutine:nil];
    }
    else {
        
        FXAlertController *eulaDeclinedAlert = [[FXAlertController alloc] initWithTitle:@"NOTE" message:@"You must accept the End User License Agreement if you want to post!"];
        
        FXAlertButton *okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeStandard];
        [okButton setTitle:@"Ok" forState:UIControlStateNormal];
        
        [eulaDeclinedAlert addButton:okButton];
        
        [self presentViewController:eulaDeclinedAlert animated:YES completion:nil];
    }

}


- (void) displayUpdateInformation {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"tapMapUpdateHasBeenSeen"] isEqualToString:@"yes"]) {
        return;
    } else {
        self.updateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Screen width], [Screen height])];
        self.updateView.alpha = 0.0;
        [SASUtilities addSASBlurToView:self.updateView];
        
        [UIView animateWithDuration:1.5 animations:^(void){
            self.updateView.alpha = 1.0;
            
            UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, [Screen width] - 30, 200)];
            infoLabel.center = self.updateView.center;
            infoLabel.frame = CGRectOffset(infoLabel.frame, 0, -30);
            infoLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
            infoLabel.textColor = [UIColor grayColor];
            infoLabel.numberOfLines = 0;
            infoLabel.textAlignment = NSTextAlignmentCenter;
            infoLabel.text = @"Coordinates sometimes may be slightly off. You can tap and hold on the map to change the location.";
            [self.updateView addSubview:infoLabel];
            
            UIImageView *infoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Megaphone"]];
            infoImageView.frame = CGRectMake(0, 140, [Screen width], 30);
            infoImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.updateView addSubview:infoImageView];
            
            UIButton *exit = [[UIButton alloc] initWithFrame:CGRectMake([Screen width] - 34, 70, 25, 25)];
            [exit setImage:[UIImage imageNamed:@"Exit"] forState:UIControlStateNormal];
            [exit addTarget:self action:@selector(removeUpdateView:) forControlEvents:UIControlEventTouchUpInside];
            [self.updateView addSubview:exit];
            
            [self.view addSubview:self.updateView];
            [self.view bringSubviewToFront:self.sasMapView];
        }];
    }
    
}


- (void) removeUpdateView:(id) sender {
    [self.updateView removeFromSuperview];
    self.updateView = nil;
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"tapMapUpdateHasBeenSeen"];
}


@end
