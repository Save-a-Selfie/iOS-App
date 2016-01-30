//
//  SASUploadImageViewController.m
//  Save a Selfie
//
//  Created by Stephen Fox on 09/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploadViewController.h"
#import "SASImageView.h"
#import "SASUtilities.h"
#import "SASAnnotation.h"
#import "UIFont+SASFont.h"
#import "Screen.h"
#import "SASBarButtonItem.h"
#import "FXAlert.h"
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
#import "CMPopTipView.h"
#import "SASDeviceButtonView.h"

#import "SASNetworkManager.h"
#import "ParseUploadWorker.h"



@interface SASUploadViewController () <UITextViewDelegate,
EULADelegate,
CMPopTipViewDelegate,
SASDeviceButtonViewDelegate>

@property (strong, nonatomic) IBOutlet SASImageView *sasImageView;
@property (weak, nonatomic) IBOutlet SASMapView *sasMapView;
@property (strong, nonatomic) SASAnnotation *sasAnnotation;

@property (weak, nonatomic) IBOutlet UILabel *selectDeviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITextView *deviceCaptionTextView;

@property (weak, nonatomic) IBOutlet SASDeviceButtonView *sasDeviceButtonView;
@property (strong, nonatomic) SASGreyView *sasGreyView;
@property (strong, nonatomic) SASActivityIndicator *sasActivityIndicator;

@property (nonatomic, assign) BOOL deviceHasBeenSelected;

@property (strong, nonatomic) EULAViewController *eulaViewController;
@property (strong, nonatomic) SASBarButtonItem *doneBarButtonItem;

@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) UIView* updateView;

@property (strong, nonatomic) SASNetworkManager *networkManager;
@end

@implementation SASUploadViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationController.navigationBar
   setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold"
                                                                 size:17.0f]}];
  
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
  
  self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(updateAnnotationOnMapView)];
  [self.sasMapView addGestureRecognizer:self.longPress];
  self.sasDeviceButtonView.delegate = self;
  
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
}


- (void) cancel {
  [self dismissSASUploadImageViewControllerWithResponse:SASUploadControllerResponseCancelled];
}



- (void) updateAnnotationOnMapView {
  if(self.longPress.state != UIGestureRecognizerStateBegan) {
    return;
  }
  
  CGPoint touchPoint = [self.longPress locationInView:self.sasMapView];
  CLLocationCoordinate2D location = [self.sasMapView convertPoint:touchPoint
                                             toCoordinateFromView:self.sasMapView];
  
  
  self.sasAnnotation.coordinate = location;
  self.sasUploadObject.coordinates = self.sasAnnotation.coordinate;
  [self.sasMapView showAnnotation:self.sasAnnotation andZoom:NO animated:NO];
}



#pragma SASDeviceButtonViewDelegate
- (void)sasDeviceButtonView:(SASDeviceButtonView *) view
             buttonSelected:(SASDeviceButton *) button {
  self.deviceHasBeenSelected = YES;
  self.sasUploadObject.associatedDevice.type = button.deviceType;
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
    
    if (!self.networkManager) {
      self.networkManager = [SASNetworkManager sharedInstance];
    }
    
    // Checks that everything is correct.
    [self preUploadChecks: ^(){
      [self.networkManager uploadWithWorker:[[ParseUploadWorker alloc] init]
                                 withObject:self.sasUploadObject
                                 completion:^(UploadCompletionStatus status) {
                                   switch (status) {
                                     case Failed:
                                       [self uploadFailure];
                                       break;
                                       case Success:
                                       [self uploadSuccess];
                                       break;
                                   }
                                 }];
      [self uploadBegan];
    }];
  }
}


- (void) uploadBegan {
  // Activity Indicator
  self.sasActivityIndicator = [[SASActivityIndicator alloc] initWithMessage:@"Posting"];
  self.sasActivityIndicator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
  [self.view addSubview:self.sasActivityIndicator];
  self.sasActivityIndicator.center = self.view.center;
  [self.sasActivityIndicator startAnimating];
  
  self.doneButton.enabled = NO;
  self.view.userInteractionEnabled = NO;
}



- (void) uploadSuccess {
  [self dismissSASUploadImageViewControllerWithResponse:SASUploadControllerResponseUploaded];
  [self.sasActivityIndicator removeFromSuperview];
  [self.sasActivityIndicator stopAnimating];
  
}


- (void) uploadFailure {
  
  self.view.userInteractionEnabled = YES;
  self.doneButton.enabled = YES;
  
  FXAlertController *uploadErrorAlert =
    [[FXAlertController alloc] initWithTitle:@"OOOPS!"
                                     message:@"There seemed to be a problem posting! Please check you're connected to Wifi/ Network and try again."];
  
  FXAlertButton *okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeCancel];
  [okButton setTitle:@"Ok" forState:UIControlStateNormal];
  
  [uploadErrorAlert addButton:okButton];
  
  [self presentViewController:uploadErrorAlert animated:YES completion:nil];
  
  [self.sasActivityIndicator removeFromSuperview];
  [self.sasActivityIndicator stopAnimating];
}



// Makes sure all information about the uploadObject is set.
// The block will be called if all checks passed.
- (void) preUploadChecks:(void(^)()) successBlock {
  
  FXAlertController *invalidUploadObjectAlert = nil;
  FXAlertButton *okButton = nil;
  
  if ( self.sasUploadObject.caption == nil ||
      [self.sasUploadObject.caption isEqualToString:@"Add Location Information"] ||
      [self.sasUploadObject.caption isEqualToString:@""]) {
    invalidUploadObjectAlert = [[FXAlertController alloc] initWithTitle:@"OOOPS!"
                                                                message:@"Please add a description for this post!"];
    okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeStandard];
    [okButton setTitle:@"Ok" forState:UIControlStateNormal];
    [invalidUploadObjectAlert addButton:okButton];
    [self presentViewController:invalidUploadObjectAlert animated:YES completion:nil];
    return;
  }
  

  if (!self.deviceHasBeenSelected) {
    invalidUploadObjectAlert = [[FXAlertController alloc] initWithTitle:@"OOOPS!"
                                                                message:@"Please select a device for this post!"];
    okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeStandard];
    [okButton setTitle:@"Ok" forState:UIControlStateNormal];
    [invalidUploadObjectAlert addButton:okButton];
    [self presentViewController:invalidUploadObjectAlert animated:YES completion:nil];
    return;
  }
  

  if (!CLLocationCoordinate2DIsValid(self.sasUploadObject.coordinates)) {
    invalidUploadObjectAlert = [[FXAlertController alloc] initWithTitle:@"OOOPS!"
                                                                message:@"Cannot determine location. Please select the map and tap the location of the device"];
    okButton = [[FXAlertButton alloc] initWithType:FXAlertButtonTypeStandard];
    [okButton setTitle:@"Ok" forState:UIControlStateNormal];
    [invalidUploadObjectAlert addButton:okButton];
    [self presentViewController:invalidUploadObjectAlert animated:YES completion:nil];
    return;
  }
  
  successBlock();
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
  if (self.delegate != nil &&
      [self.delegate respondsToSelector:@selector(sasUploadViewController:withResponse:withObject:)]) {
    
    [self.delegate sasUploadViewController:self
                              withResponse:response
                                withObject:self.sasUploadObject];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}




#pragma Check the user has agreed to the End User Licence Agreement
- (BOOL) hasEULABeenAcepted {
  BOOL EULAAccepted = [[[NSUserDefaults standardUserDefaults]
                        valueForKey:@"EULAAccepted"]
                       isEqualToString:@"yes"];
  
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
    
  }
  else {
    
    CMPopTipView *mapUpdateView = [[CMPopTipView alloc] initWithTitle:@"NEW" message:@"You can now tap and hold the map to correct coordinates that may be slightly off."];
    mapUpdateView.delegate = self;
    mapUpdateView.hasGradientBackground = NO;
    mapUpdateView.has3DStyle = NO;
    mapUpdateView.borderWidth = 0.2;
    mapUpdateView.backgroundColor = [UIColor whiteColor];
    mapUpdateView.textFont = [UIFont fontWithName:@"Avenir Next" size:16];
    mapUpdateView.titleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
    mapUpdateView.titleColor = [UIColor grayColor];
    mapUpdateView.textColor = [UIColor grayColor];
    [mapUpdateView presentPointingAtView:self.sasMapView inView:self.view animated:YES];
  }
  
}


- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
  [self.updateView removeFromSuperview];
  self.updateView = nil;
  [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"tapMapUpdateHasBeenSeen"];
}


@end
