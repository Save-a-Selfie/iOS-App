//
//  UploadPictureViewController.m
//  Save-a-Selfie
//
//  Created by Nadja Deininger on 12/05/14.
//  Copyright (c) 2014 Code for All Ireland. All rights reserved.
//

#import "UploadPictureViewController.h"
#import "UIImage+Resize.h"
#import "AlertBox.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"
#import "UIView+WidthXY.h"

@interface UploadPictureViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;
@property (weak, nonatomic) IBOutlet UITextView *commentField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property UIImagePickerController *picker;
@property (readonly) CLLocationManager *locationManager;
@property (readonly) CLLocationCoordinate2D currentLocation;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property (weak, nonatomic) IBOutlet UIButton *SASLogoButton;
@property (weak, nonatomic) IBOutlet UILabel *whiteBackground;
@property (weak, nonatomic) IBOutlet UILabel *multipurposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *multilabelBackground;
@property (weak, nonatomic) IBOutlet UILabel *typeInfoHere;
@property (weak, nonatomic) IBOutlet UIImageView *littleGuy;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//! state variable to avoid calling the sendImageToServer method multiple times
- (IBAction)OKAction:(id)sender;
- (IBAction)useCamera;
- (IBAction)useCameraRoll;
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (IBAction)sendIt:(id)sender;
- (void) sendImageToServer:(UIImage *)image;
@end

@implementation UploadPictureViewController

// local variables
CLLocation* photoLocation = nil;
NSString *photoID;
NSString *caption;
UIImage *imageToSave;
AlertBox *alert, *permissionsBox;
BOOL uploading = NO;
BOOL gettingImage = NO;
BOOL showingActionSheet = NO;
UIActionSheet *actionSheet;
BOOL pickingViaCamera;
BOOL firstLocated = YES;
float mapZoomValue = 5.0;
CGFloat screenHeight, screenWidth;
BOOL firstAppearance = YES;

// To do
//
// If no GPS on image, use user location
// Save list of uploaded photos – and ask if uploading with same name; save etc. with this info
// Save while quitting
// 'Close' button on images in website
// replace UIAlertView with AlertBox everywhere
// need to sort out compiler warnings
// littleGuy image a bit pixellated?

#pragma mark Set-up

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_SASLogoButton changeViewWidth:_SASLogoButton.frame.size.width atX:9999 centreIt:YES duration:0];
    [_OKButton changeViewWidth:_OKButton.frame.size.width atX:9999 centreIt:YES duration:0];
    self.tabBarController.tabBar.hidden = YES;
    [self makeSendButtonRed];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    [self checkPermissions];
    _whiteBackground.hidden = NO;
    [_mapView changeViewWidth:screenWidth atX:0 centreIt:YES duration:0.5];
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.hidden = YES;
    _commentField.delegate = (id<UITextViewDelegate>)self;
    _commentField.userInteractionEnabled = NO;
    _littleGuy.hidden = YES;
    [[_multilabelBackground layer] setCornerRadius:10.0f];
    [[_multilabelBackground layer] setMasksToBounds:YES];
    gettingImage = NO;
    self.tabBarController.delegate = self;
    if (!alert) {
        [[NSBundle mainBundle] loadNibNamed:@"AlertBox" owner:self options:nil];
        alert = [[AlertBox alloc] initWithFrame:CGRectMake(20, 150, 260, 90)];
        alert.center = self.view.center;
    }
    [self startLocating]; // may not need to locate user if user is just picking from Camera Roll...
    [self OKAction:self];
}

-(void)makeSendButtonRed { // turns it grey for some reason
    _sendButton.enabled = NO; // initially disabled – until user types some sort of description in commentField
    _sendButton.tintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)OKAction:(id)sender { // used be linked from an 'Enter...' button, which is now gone; performs set-ups on labels, etc.
    plog(@"OKAction");
    _OKButton.hidden = YES;
    _whiteBackground.hidden = YES;
    _SASLogoButton.hidden = YES;
    _commentField.userInteractionEnabled = YES;
    [_commentField changeViewWidth:screenWidth - 40 atX:9999 centreIt:YES duration:0];
    CGRect f = _commentField.frame;
    _typeInfoHere.frame = CGRectMake(f.origin.x + 15, f.origin.y + 15, _typeInfoHere.frame.size.width, _typeInfoHere.frame.size.height);
    [_littleGuy moveObject:-100 overTimePeriod:0];
    _littleGuy.hidden = NO;
    [_littleGuy moveObject:330 overTimePeriod:0.5];
    [_multipurposeLabel changeViewWidth:screenWidth - 52 atX:9999 centreIt:YES duration:0];
    [_multilabelBackground changeViewWidth:screenWidth - 40 atX:9999 centreIt:YES duration:0];
    [_multipurposeLabel moveObject:screenHeight + 100 overTimePeriod:0];
    _multipurposeLabel.hidden = NO;
    [_multipurposeLabel moveObject:400 overTimePeriod:0.5];
    [_multilabelBackground moveObject:screenHeight + 100 overTimePeriod:0];
    _multilabelBackground.hidden = NO;
    [_multilabelBackground moveObject:394 overTimePeriod:0.5];
    _multipurposeLabel.text = @"Tap 'Photo' below to take or retrieve a photo, or 'Locate / Info' to find a defibrillator, see photos, or learn about the project";
    float newSendX = _multilabelBackground.frame.origin.x + _multilabelBackground.frame.size.width - _sendButton.frame.size.width;
    [_sendButton changeViewWidth:_sendButton.frame.size.width atX:newSendX centreIt:NO duration:0];
    _typeInfoHere.hidden = YES;
    _commentField.hidden = YES;
    firstAppearance = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Permissions
// not all permissions sorted out yet

-(BOOL)checkPermissions {
    BOOL allGrand = NO;
   	plog(@"checking permissions");
    // checks location permissions
    if([CLLocationManager locationServicesEnabled]){
        //			plog(@"Location Services Enabled");
        
        // Switch through the possible location
        // authorization states
        switch([CLLocationManager authorizationStatus]){
            case kCLAuthorizationStatusAuthorized:
                plog(@"We have access to location services");
                allGrand = YES;
                break;
            case kCLAuthorizationStatusDenied:
                [self permissionsProblem:@"Please enable location services for this app. You need to launch the iPhone Settings app to do this (in it, go to Privacy > Location Services, scroll down until you see Smappr and switch it to 'On'). You'll have to go out of this app temporarily now, using the 'Home' button below this screen."];
                allGrand = NO;
                //					plog(@"Location services denied by user");
                break;
            case kCLAuthorizationStatusRestricted:
                plog(@"Parental controls restrict location services");
                break;
            case kCLAuthorizationStatusNotDetermined:
                plog(@"Unable to determine, possibly not available");
                allGrand = YES;
        }
    }
    else {
        // locationServicesEnabled was set to NO
        plog(@"Location Services Are Disabled");
        [self permissionsProblem:@"Please enable location services on your phone. You need to launch the iPhone Settings app to do this (in it, go to Privacy > Location Services and switch it to 'On'). You'll have to go out of this app temporarily now, using the 'Home' button below this screen."];
        allGrand = NO;
    }
    return allGrand;
}

-(void)permissionsProblem:(NSString *)message {
    [[NSBundle mainBundle] loadNibNamed:@"AlertBox" owner:self options:nil];
    int boxHeight = 240;
    if (!permissionsBox) permissionsBox = [[AlertBox alloc] initWithFrame:CGRectMake(70, (screenHeight - boxHeight) * 0.5, 220, boxHeight)];
    [permissionsBox fillAlertBox:message button1Text:nil button2Text:nil action1:nil action2:nil calledFrom:self opacity:0.85 centreText:NO];
    permissionsBox.center = self.view.center;
    //	[self addSubview:permissionsBox];
    [permissionsBox addBoxToView:self.view withOrientation:0];
}

#pragma mark - Navigation

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex != 0) { firstAppearance = YES; return; }
    if (!firstAppearance) {
        [self showActionSheet:self];
    } else firstAppearance = NO;
}

- (IBAction)showActionSheet:(id)sender {
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo", @"Choose from existing", nil];
    actionSheet.tag = 1;
    showingActionSheet = YES;
    _littleGuy.hidden = NO;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    showingActionSheet = NO;

    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self useCamera];
                    break;
                case 1:
                    [self useCameraRoll];
                    break;
            }
            break;
        }
        default:
            break;
    }
}

// todo: if no camera is available, don't even show the button, but this works for now
- (IBAction)useCamera {
    gettingImage = YES;
    pickingViaCamera = YES;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self hideLabels];
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:_picker animated:YES completion:nil];
    }
    else {
        [alert fillAlertBox:@"Problem" button1Text:@"Camera could not be found" button2Text:nil action1:@selector(removeAlert) action2:nil calledFrom:self opacity:0.85 centreText:YES];
        [alert addBoxToView:self.view withOrientation:0];
    }
}

- (IBAction)useCameraRoll {
    gettingImage = YES;
    pickingViaCamera = NO;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self hideLabels];
        [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:_picker animated:YES completion:nil];
    }
    else {
        [alert fillAlertBox:@"Problem" button1Text:@"Photo library could not be found" button2Text:nil action1:@selector(removeAlert) action2:nil calledFrom:self opacity:0.85 centreText:YES];
        [alert addBoxToView:self.view withOrientation:0];
    }
}

-(void)hideLabels {
    _multipurposeLabel.hidden = YES;
    _multilabelBackground.hidden = YES;
    _littleGuy.hidden = YES;
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [_picker dismissViewControllerAnimated:NO completion:nil];
}

// from http://stackoverflow.com/questions/1238838/uiimagepickercontroller-and-extracting-exif-data-from-existing-photos
-(CLLocation*)locationFromAsset:(ALAsset*)asset
{
    if (!asset) { plog(@"no asset"); return nil; }
    
    NSDictionary* pickedImageMetadata = [[asset defaultRepresentation] metadata];
    NSDictionary* gpsInfo = [pickedImageMetadata objectForKey:(__bridge NSString *)kCGImagePropertyGPSDictionary];
    if (gpsInfo){
        NSNumber* nLat = [gpsInfo objectForKey:(__bridge NSString *)kCGImagePropertyGPSLatitude];
        NSNumber* nLng = [gpsInfo objectForKey:(__bridge NSString *)kCGImagePropertyGPSLongitude];
        if (nLat && nLng)
            return [[CLLocation alloc]initWithLatitude:[nLat doubleValue] longitude:[nLng doubleValue]];
    }
    plog(@"no GPS info found");
    return nil;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    plog(@"Going to check GPS");
    if (!pickingViaCamera) { // may be GPS info on photo
        //UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
        NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        plog(@"asset URL is %@", assetURL);
        // e.g., asset URL is assets-library://asset/asset.JPG?id=48F4951F-319C-443F-957C-6EEE939E50C9&ext=JPG
        NSArray *a = [[NSString stringWithFormat:@"%@", assetURL] componentsSeparatedByString:@"?"];
        photoID = [a[1] stringByReplacingOccurrencesOfString:@"id=" withString:@""];
        photoID = [photoID stringByReplacingOccurrencesOfString:@"&ext=JPG" withString:@""];
        plog(@"photo ID is %@", photoID);
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            // try to retrieve gps metadata coordinates
            photoLocation = [self locationFromAsset:asset];
            plog(@"location found: %f, %f", photoLocation.coordinate.latitude, -photoLocation.coordinate.longitude);
            // move map to location
            [_locationManager stopUpdatingLocation];
            [self setLocation:photoLocation reverseLongitude:YES];
            [_mapView removeAnnotations:[_mapView annotations]];
            CLLocationCoordinate2D coord1;
            coord1.longitude = -photoLocation.coordinate.longitude;
            coord1.latitude = photoLocation.coordinate.latitude;
            MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
            myAnnotation.coordinate = coord1;
            myAnnotation.title = @"Photo";
            myAnnotation.subtitle =@"was taken here";
            [_mapView addAnnotation:myAnnotation];
        } failureBlock:^(NSError *error) {
            plog(@"Failed to get asset from library");
        }];
    } else { // image taken with camera => no GPS info available, use location CLocation
        // once iOS 8 is widely adopted, would be better to use PHPhotoLibrary to fetch the last image; see: http://stackoverflow.com/questions/8867496/get-last-image-from-photos-app
        CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:_currentLocation.latitude longitude:_currentLocation.longitude];
        photoLocation = tempLocation;
        photoID = [self getCurrentTimeStamp];
    }
    [_imageView changeViewWidth:screenWidth * 0.5 atX:screenWidth * 0.5 centreIt:NO duration:1];
    [_mapView changeViewWidth:screenWidth * 0.5 atX:0 centreIt:NO duration:1];
    if([info objectForKey:UIImagePickerControllerEditedImage]) {
        imageToSave = info[UIImagePickerControllerEditedImage];
    }
    else if([info objectForKey:UIImagePickerControllerOriginalImage]) {
        imageToSave = info[UIImagePickerControllerOriginalImage];
    }
    else {
        [alert fillAlertBox:@"Problem" button1Text:@"Selected image could not be found" button2Text:nil action1:@selector(removeAlert) action2:nil calledFrom:self opacity:0.85 centreText:YES];
        [alert addBoxToView:self.view withOrientation:0];
    }
    [_picker dismissViewControllerAnimated:YES completion:nil];
    
    // check if have already uploaded this photo
//    plog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);

    NSString *existingCaption = [[NSUserDefaults standardUserDefaults] valueForKey:photoID];
    [_imageView setImage:imageToSave];
    if (existingCaption.length > 0) {
        plog(@"already uploaded...");
        _commentField.text = existingCaption;
        _typeInfoHere.hidden = YES;
        _commentField.alpha = 1;
        _commentField.editable = NO;
        [alert fillAlertBox:@"Photo already uploaded" button1Text:@"Replace" button2Text:@"Don't replace" action1:@selector(replacePhoto) action2:@selector(doNotProceed) calledFrom:self opacity:0.85 centreText:YES];
        [alert addBoxToView:self.view withOrientation:0];
    } else {
        _typeInfoHere.hidden = NO; _commentField.alpha = 0.5; [self proceedWithPhoto];
        _commentField.text = @""; [self makeSendButtonRed];
    }
}

-(void)replacePhoto {
    _typeInfoHere.hidden = YES; _commentField.alpha = 1;
    [self makeSendButtonRed];
    [self proceedWithPhoto];
    [self removeAlert];
}

-(void)removeAlert { [alert removeFromSuperview]; }

-(void)doNotProceed { [alert removeFromSuperview]; alert = nil; }

-(void)showInstructions:(NSString *)text {
    _multipurposeLabel.numberOfLines = 0;
    _multipurposeLabel.adjustsFontSizeToFitWidth = NO;
    _multipurposeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _multipurposeLabel.text = text;
    _multipurposeLabel.hidden = NO;
    _multilabelBackground.hidden = NO;
    _multipurposeLabel.textAlignment = NSTextAlignmentLeft;
    _littleGuy.hidden = NO;
}
-(void)proceedWithPhoto {
    // now want the description
    [_littleGuy moveObject:165 overTimePeriod:0.5];
    [_multipurposeLabel moveObject:231 overTimePeriod:0.85];
    [_multilabelBackground moveObject:225 overTimePeriod:0.85];
    _commentField.hidden = NO;
    _commentField.editable = YES;
    _typeInfoHere.hidden = NO;
    [self showInstructions:@"Before uploading, please add some useful information below – name of location, where the defibrillator is in the location, etc."];
    [UIView animateWithDuration:5.0 animations:^{ _imageView.alpha = 0.5; }];
}

- (IBAction)sendIt:(id)sender {
    [self sendImageToServer:_imageView.image];
    [self shutKeyboard:_commentField];
}

- (void) sendImageToServer:(UIImage *) image {

    gettingImage = NO;
    plog(@"resizing...");
    float maxWidth = 400, thumbSize = 150;
    float ratio = maxWidth / image.size.width;
    float height, width, minDim;
    if (ratio >= 1.0) { width = image.size.width; height = image.size.height; }
    else { width = maxWidth; height = image.size.height * ratio; }
    plog(@"resizing to %f, %f (%f, %f, %f)", width, height, ratio, image.size.width, image.size.height);
    UIImage *smallerImage = [image resizedImage:CGSizeMake(width, height) interpolationQuality:kCGInterpolationHigh];
    minDim = height < width ? height : width;
    ratio = thumbSize / minDim; width *= ratio; height *= ratio;
    plog(@"resizing to %f, %f", width, height);
    UIImage *thumbnail = [smallerImage resizedImage:CGSizeMake(width, height) interpolationQuality:kCGInterpolationHigh];
    plog(@"sending...");

    _imageView.alpha = 0.25;
    NSData *imageData = UIImageJPEGRepresentation(smallerImage, 0.9);
    NSData *imageDataTh = UIImageJPEGRepresentation(thumbnail, 0.9);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:@"http://iculture.info/saveaselfie/wp-content/themes/magazine-child/iPhone.php"]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *imageStrTh = [imageDataTh base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSString *parameters = [ NSString stringWithFormat:@"id=%@&latitude=%f&longitude=%f&location=%@&caption=%@&image=%@&thumbnail=%@", photoID, photoLocation.coordinate.latitude, photoLocation.coordinate.longitude, @"", [caption stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], imageStr, imageStrTh];
                        
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
//    plog(@"parameters...%@", parameters);

    [_activityIndicator startAnimating];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload error" message:@"An error occurred establishing the HTTP connection. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else uploading = YES;
    
    [_locationManager stopUpdatingLocation];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    plog(error.description);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    plog(@"finished uploading...");
    _imageView.alpha = 1.0;
    [_activityIndicator stopAnimating];
    [self shutKeyboard:_commentField];
    _sendButton.tintColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
    _sendButton.enabled = NO;
    [_sendButton setTitle:@"Sent" forState:UIControlStateNormal];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    _multipurposeLabel.text = @"Photo uploaded – thank you!";
    _multipurposeLabel.textAlignment = NSTextAlignmentCenter;
    // save ID and caption to user's data file - to avoid duplicates
    [[NSUserDefaults standardUserDefaults] setValue:caption forKey:photoID];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSString *existingCaption = [[NSUserDefaults standardUserDefaults] valueForKey:photoID];
}

#pragma mark Location services

- (void) startLocating {
    
    if(nil == _locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
    if ([_locationManager respondsToSelector:requestSelector]) { // requestWhenInUseAuthorization only works from iOS 8
        [_locationManager performSelector:requestSelector withObject:NULL];
    }
    [_locationManager setDelegate:self];
    
    if([CLLocationManager locationServicesEnabled]) {
        [_locationManager startUpdatingLocation];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services disabled" message:@"For now, we need your location to place your selfie on the map. Would you like to turn on Location Services?" delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles:@"Yes",nil];
        [alert show];
    }
    plog(@"have started locating?");
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    _currentLocation = newLocation.coordinate;
    if (firstLocated) { [self setLocation:newLocation reverseLongitude:NO]; firstLocated = NO; }
    //        plog(@"%f",adjustedRegion.span.latitudeDelta);
    [self zoom];
}

-(void)zoom {
    // MKCoordinateSpan
    //
    // A structure that defines the area spanned by a map region.
    //
    // typedef struct {
    // 	CLLocationDegrees latitudeDelta;
    // 	CLLocationDegrees longitudeDelta;
    // } MKCoordinateSpan;
    float z2 = 0.003 * mapZoomValue;
    MKCoordinateSpan span = MKCoordinateSpanMake(z2, z2);
    [_mapView setRegion:MKCoordinateRegionMake(_currentLocation, span) animated:YES];
}

-(void) setLocation:(CLLocation *)loc reverseLongitude:(BOOL)reverse {
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(loc.coordinate.latitude, reverse ? -loc.coordinate.longitude : loc.coordinate.longitude);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 800, 800)];
    adjustedRegion.span.longitudeDelta  = 0.005;
    adjustedRegion.span.latitudeDelta  = 0.005;
    [self.mapView setRegion:adjustedRegion animated:YES];
}

#pragma mark - Text View delegates

-(void)textViewDidBeginEditing:(UITextView *)textView{
    plog(@"Did begin editing");
    _typeInfoHere.hidden = YES;
    _commentField.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(self.view.frame.origin.x, -160, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _sendButton.enabled = YES;
    _sendButton.tintColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    if ([text isEqualToString:@"\n"]){ [self shutKeyboard:textView]; return NO; }
    return YES;
}

-(void)shutKeyboard:(UITextView *)textView {
    [textView resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textViewDidChange:(UITextView *)textView{
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    plog(@"Did End editing");
    caption = textView.text;
//    caption = [caption stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    caption = [caption stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

// http://stackoverflow.com/questions/1456120/hiding-the-keyboard-when-losing-focus-on-a-uitextview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    plog(@"Touch");
    UITouch *touch = [[event allTouches] anyObject];
    if ([_commentField isFirstResponder] && [touch view] != _commentField) {
        [_commentField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

# pragma Timestamp
// from here: http://stackoverflow.com/questions/22359090/get-current-time-in-timestamp-format-ios
- (NSString *)getCurrentTimeStamp {
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyyMMddHHmmss"];
    NSString    *strTime = [objDateformat stringFromDate:[NSDate date]];
    NSString    *strUTCTime = [self getUTCDateTimeFromLocalTime:strTime];
//    NSDate *objUTCDate  = [objDateformat dateFromString:strUTCTime];
//    long long milliseconds = (long long)([objUTCDate timeIntervalSince1970] * 1000.0);
//    
//    NSString *strTimeStamp = [NSString stringWithFormat:@"%lld",milliseconds];
//    plog(@"The Timestamp is = %@", strTimeStamp);
//    return strTimeStamp;
    plog(@"The Timestamp is = %@", strUTCTime);
    return strUTCTime;
}

- (NSString *)getUTCDateTimeFromLocalTime:(NSString *)IN_strLocalTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate  *objDate    = [dateFormatter dateFromString:IN_strLocalTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *strDateTime   = [dateFormatter stringFromDate:objDate];
    return strDateTime;
}

@end
