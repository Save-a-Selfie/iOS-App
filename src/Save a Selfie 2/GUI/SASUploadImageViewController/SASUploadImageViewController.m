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
#import "SASGreyView.h"

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



@end

@implementation SASUploadImageViewController

@synthesize sasImageView;
@synthesize sasUploadObject;
@synthesize sasMapView;
@synthesize sasAnnotation;
@synthesize sasGreyView;
@synthesize sasActivityIndicator;

@synthesize defibrillatorButton;
@synthesize lifeRingButton;
@synthesize firstAidKitButton;
@synthesize fireHydrantButton;
@synthesize deviceButtonsArray;
@synthesize selectDeviceLabel;
@synthesize doneButton;
@synthesize deviceHasBeenSelected;
@synthesize doneBarButtonItem;

@synthesize longPress;

@synthesize sasUploader;
@synthesize eulaViewController;

- (IBAction)expandMapView:(id)sender {
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         CGRect frame;
                         frame.size.width = [Screen width];
                         frame.size.height = [Screen height];
                         frame.origin = CGPointMake(0, 0);
                         
                         self.sasMapView.frame = frame;
                     }
                     completion:nil];
}


- (void) putAnnotationToView {
    if(self.longPress.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [self.longPress locationInView:self.sasMapView];
    CLLocationCoordinate2D location = [self.sasMapView convertPoint:touchPoint toCoordinateFromView:self.sasMapView];
    
    self.sasAnnotation.coordinate = location;
    [self.sasMapView showAnnotation:self.sasAnnotation andZoom:NO animated:NO];
    printf("touched");
    
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
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(putAnnotationToView)];
    [self.sasMapView addGestureRecognizer:self.longPress];
    
    
    self.sasAnnotation.coordinate = self.sasUploadObject.coordinates;
    
    self.sasMapView.sasAnnotationImage = DefaultAnnotationImage;
    [self.sasMapView showAnnotation:self.sasAnnotation andZoom:YES animated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    


//    self.doneButton.hidden = YES;
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



#pragma mark SASUploaderDelegate
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
    
    SASAlertView *uploadErrorAlert = [[SASAlertView alloc] initWithTarget:self andAction:nil];
    uploadErrorAlert.title = @"Ooops!";
    uploadErrorAlert.message = @"There seemed to be a problem posting! Please check you're connected to Wifi/ Network and try again.";
    uploadErrorAlert.buttonTitle = @"Ok";
    
    [uploadErrorAlert animateIntoView:self.view];
    
    [self.sasActivityIndicator removeFromSuperview];
    [self.sasActivityIndicator stopAnimating];
}



- (void)sasUploader:(SASUploadObject *)object invalidObjectWithResponse:(SASUploadInvalidObject)response {
    
    SASAlertView *alertView = [[SASAlertView alloc] initWithTarget:self andAction:nil];
     
    switch (response) {
        
        case SASUploadInvalidObjectCaption:
            alertView.title = @"Ooops!";
            alertView.message = @"Please add a description for this post!";
            alertView.buttonTitle = @"Ok";
            [alertView animateIntoView:self.view];
            break;
            
            
        case SASUploadInvalidObjectDeviceType:
            alertView.title = @"Ooops!";
            alertView.message = @"Please select a device for this post!";
            alertView.buttonTitle = @"Ok";
            [alertView animateIntoView:self.view];
            
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

// TODO: The alerts for this notice should be SASAlertView, however, due to some weird
// issue with the view hierarcy, this will do for the moment.
- (void) showAlertForEULAToBeAccepted {
    
    if(SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"7.1")) {
        UIAlertView *eulaAlertView = [[UIAlertView alloc] initWithTitle:@"Note"
                                                                message:@"Before posting, we need you to agree to the terms of use."
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Show Me", nil];
        
        [eulaAlertView show];
    }
    else {
        UIAlertController *eulaAlertController = [UIAlertController alertControllerWithTitle:@"Note"
                                                                                     message:@"Before posting, we need you to agree to the terms of use."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *showMeAction = [UIAlertAction actionWithTitle:@"Show Me"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction* acceptAction){
                                                                 [self presentEULAViewController];
                                                             }];
        [eulaAlertController addAction:showMeAction];
        [self presentViewController:eulaAlertController animated:YES completion:nil];
    }
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
        SASAlertView *eulaDeclinedAlertView = [[SASAlertView alloc] initWithTarget:self andAction:nil];
        eulaDeclinedAlertView.title = @"NOTE";
        eulaDeclinedAlertView.message = @"You will only be able to upload if you accept the End User License Agreement.";
        eulaDeclinedAlertView.buttonTitle = @"Ok";
        
        [eulaDeclinedAlertView animateIntoView:self.view];
    }

}


@end
