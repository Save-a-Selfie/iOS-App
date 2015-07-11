//
//  UploadPictureViewController.m
//  Save-a-Selfie
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import "UploadPictureViewController.h"
#import "UIImage+Resize.h"
#import "AlertBox.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"
#import "UIView+WidthXY.h"
#import "EmergencyObjects.h"
#import "UIView+NibInitializer.h"


#import "PopupImage.h"
#import "UIButton+Maker.h"
#import "UIView+Alert.h"

//#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface UploadPictureViewController ()
@end

@implementation UploadPictureViewController

// local variables
CLLocation* photoLocation = nil;
NSString *photoID;
NSString *caption;
UIImage *imageToSave;
AlertBox *alert, *permissionsBox;
BOOL uploading = NO;
BOOL showingActionSheet = NO;
UIActionSheet *actionSheet;
BOOL pickingViaCamera;
BOOL firstLocated = YES;
float mapZoomValue = 4.0;
CGFloat screenHeight, screenWidth;
BOOL firstAppearance = YES;
BOOL shareOnFacebook = YES;
EmergencyObjects *emergencyObjects;
BOOL commentFieldAltered = NO;
NSMutableData *responseData;
UIImage *largerImage;
UIImageView *uploadingImageView;
UILabel *uploadLabel;
NSTimer *uploadTimer;
UIButton *sendButton;
CLLocationManager *locationManager;
CLLocationCoordinate2D currentLocation;
BOOL mappingAllowed = NO;
NSString *permissionsProblem1 = @"Please enable location services for this app. Launch the iPhone Settings app to do this. Go to Privacy > Location Services > Save a Selfie > While Using the App. You have to go out of this app, using the 'Home' button.";
NSString *permissionsProblem2 = @"Please enable location services on your phone. Launch the iPhone Settings app to do this. Go to Privacy > Location Services > On. You have to go out of this app, using the 'Home' button.";
extern NSString *const applicationWillEnterForeground;
extern NSString *const objectChosen;
extern NSString *const handledFBResponse;
extern int chosenObject;
extern BOOL FBLoggedIn;
extern UIFont *customFont, *customFontSmaller;

#pragma mark Set-up

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    
    // change tab bar icon and title – have swapped out initial FacebookVC
    UITabBarController *tabBarController = (UITabBarController *)self.tabBarController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    tabBarItem1.title = @"Photo";
    [tabBarItem1 setImage:[UIImage imageNamed:@"camera"]];
    
    // move buttons off-screen
    [_SASLogoButton changeViewWidth:_SASLogoButton.frame.size.width atX:9999 centreIt:YES duration:0];
    [_OKButton changeViewWidth:_OKButton.frame.size.width atX:9999 centreIt:YES duration:0];
    [_sendToFBButton moveObject:screenHeight + 100 overTimePeriod:0];
    [_sendToFBLabel moveObject:screenHeight + 100 overTimePeriod:0];
    
    //    self.tabBarController.tabBar.hidden = YES;

    _mapView.userInteractionEnabled = [self checkPermissions];
    _whiteBackground.hidden = NO;
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.hidden = YES;
    _commentField.delegate = (id<UITextViewDelegate>)self;
    _commentField.userInteractionEnabled = NO;
    _commentField.hidden = YES;
    _littleGuy.hidden = YES;
    // dull out Send button
    [self makeSendButtonGrey];
    _backArrow.hidden = YES; // not going to use – causes crash
    [[_multilabelBackground layer] setCornerRadius:10.0f];
    [[_multilabelBackground layer] setMasksToBounds:YES];
    self.tabBarController.delegate = self;
    [self startLocating]; // may not need to locate user if user is just picking from Camera Roll...
    [self OKAction:self];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(clearPermissionsBox)
     name:applicationWillEnterForeground
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(objectTypeChosen)
     name:objectChosen
     object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    plog(@"viewWillAppear");
    [super viewWillAppear:animated]; [self startLocating];
}

-(AlertBox *)newAlert { return [self newAlertWithHeight:90]; }

-(AlertBox *)newAlertWithHeight:(float)height {
    if (alert) { [self removeAlert]; }
    return [self.view makeAlertWithHeight:height];
}

-(void)showPermissionsProblem:(NSString *)text {
    [self clearPermissionsBox];
    permissionsBox = [self.view permissionsProblem:text];
}

-(void)clearPermissionsBox { // called when returning from outside app
    if (permissionsBox) [permissionsBox removeFromSuperview]; permissionsBox = nil;
}

-(void)makeSendButtonGrey { // turns it grey for some reason
    float buttonHeight = 33.0;
    float buttonWidth = 50;
    if (sendButton) {
        [sendButton removeFromSuperview]; sendButton = nil;
    }
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton = [UIButton makeButton:@"Next" addShine:NO dimensions:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    sendButton.hidden = YES;
    sendButton.titleLabel.font = customFont;
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [sendButton addTarget:self action:@selector(sendIt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    sendButton.enabled = NO; // initially disabled – until user types some sort of description in commentField
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)OKAction:(id)sender { // performs set-ups on labels, etc.
    plog(@"OKAction");
    _OKButton.hidden = YES;
    _whiteBackground.hidden = YES;
    _SASLogoButton.hidden = _typeInfoHere.hidden = YES;
    _commentField.userInteractionEnabled = YES;
    _mapView.frame = CGRectMake(0, _mapView.frame.origin.y, _mapView.frame.size.width, screenHeight * 0.5);
    _imageView.frame = CGRectMake(screenWidth * 0.5, _mapView.frame.origin.y, _mapView.frame.size.width, screenHeight * 0.5);
    [_mapView changeViewWidth:screenWidth atX:0 centreIt:YES duration:0.5];
    [_littleGuy moveObject:-100 overTimePeriod:0];
    _littleGuy.hidden = NO;
    [_littleGuy moveObject:(_mapView.frame.origin.y + _mapView.frame.size.height - 30) overTimePeriod:0.5];
    [_multipurposeLabel changeViewWidth:screenWidth - 52 atX:9999 centreIt:YES duration:0];
    [_multilabelBackground changeViewWidth:screenWidth - 40 atX:9999 centreIt:YES duration:0];
    [_multipurposeLabel moveObject:screenHeight + 100 overTimePeriod:0];
    _multipurposeLabel.hidden = NO;
    _multipurposeLabel.font = customFont;
    [_multipurposeLabel moveObject:_littleGuy.frame.origin.y + 70 overTimePeriod:0.5];
    [_multilabelBackground moveObject:screenHeight + 100 overTimePeriod:0];
    _multilabelBackground.hidden = NO;
    plog(@"OKAction 2");
    [_multilabelBackground moveObject:_multipurposeLabel.frame.origin.y - 6 overTimePeriod:0.5];
    _multipurposeLabel.text = @"Tap 'Photo' below to take or retrieve a photo, or 'Locate' to find a device and see photos, or 'Info' to learn about the project";
    firstAppearance = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (emergencyObjects) { [emergencyObjects removeFromSuperview]; emergencyObjects = nil; }
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
    pickingViaCamera = YES;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self hideLabels];
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:_picker animated:YES completion:nil];
    }
    else {
        [[self newAlert] fillAlertBox:@"Problem:no camera!" button1Text:@"OK" button2Text:nil action1:@selector(removeAlert) action2:nil calledFrom:self opacity:0.85 centreText:YES];
        [alert addBoxToView:self.view withOrientation:0];
    }
}

- (IBAction)useCameraRoll {
    pickingViaCamera = NO;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self hideLabels];
        [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:_picker animated:YES completion:nil];
    }
    else {
        [[self newAlert] fillAlertBox:@"Problem" button1Text:@"Photo library could not be found" button2Text:nil action1:@selector(removeAlert) action2:nil calledFrom:self opacity:0.85 centreText:YES];
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
            return [[CLLocation alloc]initWithLatitude:[nLat doubleValue] longitude:-[nLng doubleValue]]; // ! sign of longitude is incorrect in retrieved photos !
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
        
        // try to retrieve gps metadata coordinates
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            photoLocation = [self locationFromAsset:asset];
            plog(@"location found: %f, %f", photoLocation.coordinate.latitude, photoLocation.coordinate.longitude);
            
            // move map to location
            [locationManager stopUpdatingLocation];
            [self setLocation:photoLocation reverseLongitude:NO];
            
            // add a marker to the map at location of snap
            [_mapView removeAnnotations:[_mapView annotations]];
            CLLocationCoordinate2D coord1;
            coord1.longitude = photoLocation.coordinate.longitude;
            coord1.latitude = photoLocation.coordinate.latitude;
            MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
            myAnnotation.coordinate = coord1;
            myAnnotation.title = @"Photo";
            myAnnotation.subtitle = @"was taken here";
            [_mapView addAnnotation:myAnnotation];
            
        } failureBlock:^(NSError *error) {
            plog(@"Failed to get GPS info for photo"); // ** need to deal with this fail
        }];
    } else { // image taken with camera => no GPS info available, use location CLocation
        // once iOS 8 is widely adopted, would be better to use PHPhotoLibrary to fetch the last image; see: http://stackoverflow.com/questions/8867496/get-last-image-from-photos-app
        CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
        photoLocation = tempLocation;
        photoID = [self getCurrentTimeStamp];
    }
    
    // set image and map widths to half screen width
    [_imageView changeViewWidth:screenWidth * 0.5 atX:screenWidth * 0.5 centreIt:NO duration:1];
    [_mapView changeViewWidth:screenWidth * 0.5 atX:0 centreIt:NO duration:1];
    
    if([info objectForKey:UIImagePickerControllerEditedImage]) {
        imageToSave = info[UIImagePickerControllerEditedImage];
    }
    else if([info objectForKey:UIImagePickerControllerOriginalImage]) {
        imageToSave = info[UIImagePickerControllerOriginalImage];
    }
    else {
        [[self newAlert] fillAlertBox:@"Problem" button1Text:@"Selected image could not be found" button2Text:nil action1:@selector(removeAlert) action2:nil calledFrom:self opacity:0.85 centreText:YES];
        [alert addBoxToView:self.view withOrientation:0]; // ** need to deal with this fail
    }
    
    [_picker dismissViewControllerAnimated:YES completion:nil];
    
    // check if have already uploaded this photo
    //    plog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    NSString *existingCaption = [self decodeFromPercentEscapeString:[[NSUserDefaults standardUserDefaults] valueForKey:photoID]];
    [_imageView setImage:imageToSave];
    if (existingCaption.length > 0) {
        plog(@"already uploaded...");
        // it's OK – ask if user wants to replace it
        _commentField.text = existingCaption;
        _commentField.alpha = 1;
        _commentField.editable = NO;
        _typeInfoHere.hidden = YES;
        [[self newAlert] fillAlertBox:@"Photo already uploaded" button1Text:@"Replace" button2Text:@"Don't replace" action1:@selector(replacePhoto) action2:@selector(doNotProceed) calledFrom:self opacity:0.85 centreText:YES];
        [alert addBoxToView:self.view withOrientation:0];
        [alert moveObject:screenHeight + 350 overTimePeriod:0];
        [alert moveObject:screenHeight * 0.66 overTimePeriod:0.75];
    } else {
        plog(@"NOT already uploaded...");
        _typeInfoHere.hidden = NO; _commentField.alpha = 0.5;
        _commentField.text = @""; [self makeSendButtonGrey];
        [self getTheDescription];
    }
}

- (UIImage *) doubleMerge: (UIImage *) photo
                withImage:(UIImage *) logo1 atX: (int) x andY:(int)y withStrength:(float) mapOpacity
                 andImage:(UIImage *) logo2 atX2:(int) x2 andY2:(int)y2
                 strength: (float) strength {
    float extraHeight = 0.0;
    // see http://stackoverflow.com/questions/10931155/uigraphicsbeginimagecontextwithoptions-and-multithreading re calling UIGraphicsBeginImageContextWithOptions on background thread – apparently it's fine
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([photo size].width,[photo size].height + extraHeight), NO, 1.0); // last parameter is scaling - should be 1.0 not 0.0, or doubles image size
    [photo drawAtPoint: CGPointMake(0,0)];
    
    plog(@"height of logo 1 is %f, of logo 2 is %f", logo1.size.height, logo2.size.height);
    [logo1 drawAtPoint: CGPointMake(x, y)
             blendMode: kCGBlendModeNormal
                 alpha: strength]; // 0 - 1
    [logo2 drawAtPoint: CGPointMake(x2, y2)
             blendMode: kCGBlendModeNormal
                 alpha: strength]; // 0 - 1
    UIImage *mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergedImage;
}

-(void)replacePhoto {
    _typeInfoHere.hidden = YES; _commentField.alpha = 1;
    [self enableSendButton];
    [self removeAlert];
    [self getTheDescription];
}

-(void)enableSendButton {
    sendButton.enabled = YES;
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setBackgroundColor:[UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:0.75]];
    
    // http://benscheirman.com/2011/09/creating-a-glow-effect-for-uilabel-and-uibutton/
    UIColor *color = sendButton.currentTitleColor;
    sendButton.titleLabel.layer.shadowColor = [color CGColor];
    sendButton.titleLabel.layer.shadowRadius = 4.0f;
    sendButton.titleLabel.layer.shadowOpacity = .9;
    sendButton.titleLabel.layer.shadowOffset = CGSizeZero;
    sendButton.titleLabel.layer.masksToBounds = NO;
}

-(void)removeAlert { [alert removeFromSuperview]; alert = nil; }

-(void)doNotProceed {
    [self removeAlert];
    [self doNotProceedPt2];
}

-(void)doNotProceedPt2 {
    [_sendToFBButton moveObject:screenHeight + 200 overTimePeriod:1.1];
    [_sendToFBLabel moveObject:screenHeight + 200 overTimePeriod:1.3];
    [sendButton moveObject:screenHeight + 200 overTimePeriod:1.5];
    [_typeInfoHere moveObject:screenHeight + 200 overTimePeriod:1.7];
    [_commentField moveObject:screenHeight + 200 overTimePeriod:1.9];
    [self OKAction:self];
}

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
-(void)getTheDescription {
    // now want the description; when the user has typed something in the description field then the 'Next' button will be enabled, allowing the user to proceed to the final stage
    [self showInstructions:@"Before uploading, please add some useful information below – name of location, where the device is in the location, etc."];
    [_littleGuy moveObject:screenHeight * 0.22 overTimePeriod:0.5];
    [_multipurposeLabel moveObject:screenHeight * 0.22 + 66 overTimePeriod:0.6];
    [_multilabelBackground moveObject:screenHeight * 0.22 + 60 overTimePeriod:0.6];
    float bottomOfMap = _mapView.frame.size.height + _mapView.frame.origin.y;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // may have moved label up too far on iPhone 6+
        float dist = bottomOfMap - (_multilabelBackground.frame.origin.y + _multilabelBackground.frame.size.height);
        if (dist > 50) {
            dist -= 50;
            [_littleGuy moveObject:_littleGuy.frame.origin.y + dist overTimePeriod:0.25];
            [_multipurposeLabel moveObject:_multipurposeLabel.frame.origin.y + dist overTimePeriod:0.25];
            [_multilabelBackground moveObject:_multilabelBackground.frame.origin.y + dist  overTimePeriod:0.25];
        }
    });
    _multipurposeLabel.font = customFont;
//    [_backArrow moveObject:_sendButton.frame.origin.y + 5 overTimePeriod:0.5];
    //    _backArrow.frame = CGRectOffset(_backArrow.frame, 0, -18);
    // fade out the photo, as the instructions have come up in front of it
    [UIView animateWithDuration:5.0 animations:^{ _imageView.alpha = 0.5; }];
    float commentFieldHeight = (screenHeight - _commentField.frame.origin.y - 60);
//    float bottomOfMap = screenHeight * 0.25 + 66 + _multilabelBackground.frame.size.height;
    //    commentFieldAltered = FBLoggedIn;
    //    plog(@"1b commentFieldAltered: %d", commentFieldAltered);
    plog(@"1 commentFieldHeight: %f", commentFieldHeight);
//    if (commentFieldHeight < 60) commentFieldHeight = 60;
    float newSendX = _multilabelBackground.frame.origin.x + _multilabelBackground.frame.size.width - sendButton.frame.size.width;
    if (!sendButton.enabled) [self makeSendButtonGrey];
    [sendButton changeViewWidth:sendButton.frame.size.width atX:newSendX centreIt:NO duration:0];
    [sendButton setTitle:@"Next" forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(sendButton.frame.origin.x, -200, sendButton.frame.size.width, sendButton.frame.size.height);
    [sendButton moveObject:bottomOfMap + 10 overTimePeriod:0.5];
    sendButton.hidden = _commentField.hidden = NO; _commentField.editable = YES;
    _typeInfoHere.hidden = _commentField.text.length != 0;
    _commentField.frame = CGRectMake(_commentField.frame.origin.x, screenHeight + 100, 0, screenHeight - bottomOfMap - 115);
    [_commentField changeViewWidth:screenWidth - 40 atX:9999 centreIt:YES duration:0];
    _typeInfoHere.frame = CGRectMake(_commentField.frame.origin.x + 5, screenHeight + 200, _typeInfoHere.frame.size.width, _typeInfoHere.frame.size.height);
    plog(@"comment field height: %f", _commentField.frame.size.height);
    plog(@"comment field y: %f", _commentField.frame.origin.y);
    [self.view bringSubviewToFront:_typeInfoHere];
    [_commentField moveObject:bottomOfMap + 50 overTimePeriod:0.75];
    [_typeInfoHere moveObject:bottomOfMap + 55 overTimePeriod:0.85];
    //    _backArrow.frame = CGRectMake(_multilabelBackground.frame.origin.x, _littleGuy.frame.origin.y + 35, _backArrow.frame.size.width, _backArrow.frame.size.height);
    if (FBLoggedIn) {
//        plog(@"2 commentFieldAltered: %d (%d, $f)", commentFieldAltered, FBLoggedIn, _commentField.frame.origin.y);
//        if (!commentFieldAltered) _commentField.frame = CGRectMake(_commentField.frame.origin.x, _commentField.frame.origin.y, _commentField.frame.size.width, _commentField.frame.size.height - 50);
//        commentFieldAltered = YES;
//        plog(@"2 comment field height: %f", _commentField.frame.size.height);
        _sendToFBButton.frame = CGRectMake(_commentField.frame.origin.x, screenHeight + 20, _sendToFBButton.frame.size.width, _sendToFBButton.frame.size.height);
        _sendToFBLabel.frame = CGRectMake(_sendToFBLabel.frame.origin.x, screenHeight + 200, _sendToFBLabel.frame.size.width, _sendToFBLabel.frame.size.height);
        [_sendToFBButton moveObject:bottomOfMap + 10 overTimePeriod:0.5];
        [_sendToFBLabel moveObject:bottomOfMap + 15 overTimePeriod:0.5];
    }
}

#pragma mark Send image to server

- (IBAction)sendIt:(id)sender { // not ready to send quite yet: find out which type of object (AED, life-ring, etc.)
    [self shutKeyboard:_commentField];
    // move little guy etc. down
    [_littleGuy moveObject:260 overTimePeriod:0.5];
    [self.view bringSubviewToFront:_multilabelBackground]; [self.view bringSubviewToFront:_multipurposeLabel]; [self.view bringSubviewToFront:_littleGuy];
    [_multipurposeLabel moveObject:330 overTimePeriod:0.5];
    [_multilabelBackground moveObject:324 overTimePeriod:0.5];
    _multipurposeLabel.text = @"Please select one of the devices above, corresponding to what is in the photo.";
    [_multipurposeLabel changeViewWidth:screenWidth - screenWidth * 0.225 - 14 atX:screenWidth * 0.225 centreIt:NO duration:0.5];
    [_multilabelBackground changeViewWidth:screenWidth - screenWidth * 0.225 - 2 atX:screenWidth * 0.225 - 6 centreIt:NO duration:0.5];
    
    // display set of four objects
    if (emergencyObjects) { [emergencyObjects removeFromSuperview]; emergencyObjects = nil; }
    emergencyObjects = [[EmergencyObjects alloc] initWithNibNamed:nil];
    [emergencyObjects EmergencyObjectsViewLoaded];
    [self.view insertSubview:emergencyObjects belowSubview:_multilabelBackground];
    // when user has chosen which type of object, program will move on to objectTypeChosen
}

-(void)objectTypeChosen {
    // comes here after user chooses object type via EmergencyObjects.m
    plog(@"chosen object: %d", chosenObject);
    [emergencyObjects moveObject:-emergencyObjects.frame.size.height overTimePeriod:0.75]; // hide display of object types
    if(chosenObject >= 0) { // -1 => cancelled
        [self sendImageToServer];
        [self shareViaFB];
    } else [self doNotProceedPt2];
}

- (void) sendImageToServer {
    
    // have got the photo, the description, and know what type of emergency object it is – ready to upload
    
    // first, resize image
    UIImage *image = _imageView.image;
    plog(@"resizing...");
    
    float maxWidth = 400, thumbSize = 150;
    float ratio = maxWidth / image.size.width;
    float height, width, minDim, tWidth, tHeight;
    
    if (ratio >= 1.0) {
        width = image.size.width;
        height = image.size.height;
    }
    else { width = maxWidth;
        height = image.size.height * ratio;
    }
    
    plog(@"resizing to %f, %f (%f, %f, %f)", width, height, ratio, image.size.width, image.size.height);
    
    largerImage = [image resizedImage:CGSizeMake(width, height) interpolationQuality:kCGInterpolationHigh];
    
    // generate thumbnail
    minDim = height < width ? height : width;
    ratio = thumbSize / minDim; tWidth = width * ratio; tHeight = height * ratio;
    plog(@"resizing to %f, %f", tWidth, tHeight);
    UIImage *thumbnail = [largerImage resizedImage:CGSizeMake(tWidth, tHeight) interpolationQuality:kCGInterpolationHigh];
    
    // add 'watermarks'
    largerImage = [self doubleMerge:largerImage withImage:[UIImage imageNamed:@"Order of Malta 70px high"] atX:20 andY:20 withStrength:1.0 andImage:[UIImage imageNamed:@"Code for ireland logo transparent85rounded"] atX2:width - 105 andY2:height - 70 strength:1.0];
    
    _imageView.alpha = 0.25; // fade photo
    
    // construct information for uploading
    NSData *imageData = UIImageJPEGRepresentation(largerImage, 0.9);
    NSData *imageDataTh = UIImageJPEGRepresentation(thumbnail, 0.9);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    NSString *URL = @"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/iPhone.php";
    [request setURL:[NSURL URLWithString:URL]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]; // the large (i.e., not thumbnail) image converted to a base-64 string
    NSString *imageStrTh = [imageDataTh base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]; // the thumbnail image converted to a base-64 string
    caption = [self encodeToPercentEscapeString:caption]; // the caption for the image – as entered by the user
    plog(@"caption is %@", caption);
    NSString *parameters = [ NSString stringWithFormat:@"id=%@&typeOfObject=%d&latitude=%f&longitude=%f&location=%@&user=%@&caption=%@&image=%@&thumbnail=%@",
                            photoID,
                            chosenObject,
                            photoLocation.coordinate.latitude,
                            photoLocation.coordinate.longitude,
                            @"",
                            @"",
                            caption,
                            imageStr,
                            imageStrTh];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    plog(@"URL: %@?%@", URL, parameters);
    
    [_activityIndicator startAnimating];
    responseData = [[NSMutableData alloc] init];
    [responseData setLength:0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection)
    {
        [[self newAlert] fillAlertBox:@"Connection error – please try later" button1Text:@"OK" button2Text:nil action1:@selector(removeAlert) action2:nil calledFrom:self opacity:0.85 centreText:YES];
        [alert addBoxToView:self.view withOrientation:0];
    } else {
        uploading = YES;
        [self uploadingImage];
    }
    
    [_littleGuy moveObject:screenHeight overTimePeriod:0.25];
    [_multipurposeLabel moveObject:screenHeight overTimePeriod:0.25];
    [_multilabelBackground moveObject:screenHeight overTimePeriod:0.25];
    
    [locationManager stopUpdatingLocation];
    
}

-(void)uploadingImage {
    plog(@"uploading image");
    uploadLabel = [[UILabel alloc]initWithFrame:_commentField.frame];
    [self.view addSubview:uploadLabel];
    uploadLabel.backgroundColor = [UIColor colorWithRed:0.3 green:1 blue:0.3 alpha:0.1];
    uploadLabel.text = @"Uploading...";
    uploadLabel.font =[UIFont fontWithName:@"TradeGothic LT" size:30];
    uploadLabel.textAlignment = NSTextAlignmentCenter;
    uploadLabel.textColor = [UIColor blackColor];
//    uploadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SAS_75"]];
//    [uploadLabel addSubview:uploadingImageView];
//    uploadingImageView.center = CGPointMake(uploadingImageView.frame.size.width * 0.5, uploadLabel.frame.size.height * 0.5);
    uploadTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(moveUploadImage) userInfo:nil repeats:YES];
}

- (void)moveUploadImage {
//    if (uploadingImageView.frame.origin.x <= (uploadLabel.frame.size.width - uploadingImageView.frame.size.width * 2 - 10))
//        uploadingImageView.center = CGPointMake(uploadingImageView.frame.origin.x + uploadingImageView.frame.size.width, uploadingImageView.center.y);
//    else uploadingImageView.center = CGPointMake(uploadingImageView.frame.size.width * 0.5, uploadLabel.center.y);
    float targetOpacity = uploadLabel.alpha > 0.6 ? 0.15 : 1.0;
    [UIView animateWithDuration:0.225 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ uploadLabel.alpha = targetOpacity;}
                     completion:nil];
}

// Encode a string to embed in an URL. See http://cybersam.com/ios-dev/proper-url-percent-encoding-in-ios
-(NSString*) encodeToPercentEscapeString:(NSString *)string {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef) string,
                                                              NULL,
                                                              (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
}

// Decode a percent escape encoded string. See http://cybersam.com/ios-dev/proper-url-percent-encoding-in-ios
-(NSString*) decodeFromPercentEscapeString:(NSString *)string {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                              (CFStringRef) string,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    //plog(error.caption);
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    plog(@"response received %@", response);
}

-(void) connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data{
    plog(@"data received - length %d (%d)", data.length, responseData.length);
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    plog(@"finished uploading..., response: %@", data);
    _imageView.alpha = 1.0;
    [_activityIndicator stopAnimating];
    [self shutKeyboard:_commentField];
    sendButton.tintColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
//    sendButton.enabled = NO;
    //    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    _multipurposeLabel.text = @"Photo uploaded – thank you! (If you need to make any changes, you can still do so – type below, then click on 'Next'.)";
    _multipurposeLabel.textAlignment = NSTextAlignmentCenter;
    _multipurposeLabel.font = customFont;
    // move little guy etc. down
    [_littleGuy moveObject:160 overTimePeriod:0.5];
    [_multipurposeLabel moveObject:230 overTimePeriod:0.5];
    [_multilabelBackground moveObject:224 overTimePeriod:0.5];
    [_multipurposeLabel changeViewWidth:screenWidth - 52 atX:26 centreIt:YES duration:0.5];
    [_multilabelBackground changeViewWidth:screenWidth - 40 atX:20 centreIt:YES duration:0.5];
    [uploadLabel removeFromSuperview];
    [uploadingImageView removeFromSuperview];
    [uploadTimer invalidate]; uploadTimer = nil;
    
    // save ID and caption to user's data file - to avoid duplicates
    [[NSUserDefaults standardUserDefaults] setValue:caption forKey:photoID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    NSString *existingCaption = [[NSUserDefaults standardUserDefaults] valueForKey:photoID];
}

#pragma mark Location services

- (void)startLocating {
//    plog(@"mapping allowed: %d", mappingAllowed);
//    if (mappingAllowed) return;
    if(nil == locationManager) { locationManager = [[CLLocationManager alloc] init]; }
    [locationManager setDelegate:self];
    if ([locationManager respondsToSelector:NSSelectorFromString(@"requestWhenInUseAuthorization")]) { // requestWhenInUseAuthorization only works from iOS 8
        plog(@"2 mapping allowed: %d", mappingAllowed);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _mapView.userInteractionEnabled = [self checkPermissions];
        });
        [locationManager requestWhenInUseAuthorization];
    } else {
        [locationManager startUpdatingLocation];
        mappingAllowed = YES;
    }
    _mapView.pitchEnabled = [_mapView respondsToSelector:NSSelectorFromString(@"setPitchEnabled")];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    plog(@"didChangeAuthorizationStatus");
    _mapView.userInteractionEnabled = [self checkPermissions];
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager startUpdatingLocation]; mappingAllowed = YES;
    }
}

-(BOOL)checkPermissions {
    BOOL allGrand = NO;
    plog(@"checking permissions");
    if (permissionsBox) [permissionsBox removeFromSuperview]; // get rid of any existing permissions box blocking access to camera etc.
    if([CLLocationManager locationServicesEnabled]){
        switch([CLLocationManager authorizationStatus]){
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                plog(@"We have access to location services");
                allGrand = YES;
                break;
            case kCLAuthorizationStatusDenied:
                plog(@"Location services denied by user");
                [self showPermissionsProblem:permissionsProblem1];
                break;
            case kCLAuthorizationStatusRestricted:
                plog(@"Parental controls restrict location services");
                break;
            case kCLAuthorizationStatusNotDetermined:
                plog(@"Unable to determine, possibly not available");
                allGrand = YES;
        }
    } else {
        // locationServicesEnabled is set to NO
        plog(@"Location Services Are Disabled");
        [self showPermissionsProblem:permissionsProblem2];
    }
    return allGrand;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    currentLocation = newLocation.coordinate;
    if (firstLocated) { [self setLocation:newLocation reverseLongitude:NO]; firstLocated = NO; }
    //    plog(@"didUpdateLocations with %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
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
    [_mapView setRegion:MKCoordinateRegionMake(currentLocation, span) animated:YES];
}

-(void) setLocation:(CLLocation *)loc reverseLongitude:(BOOL)reverse {
    // moves mapView to specified location; longitude may need reversing
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(loc.coordinate.latitude, reverse ? -loc.coordinate.longitude : loc.coordinate.longitude);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 800, 800)];
    adjustedRegion.span.longitudeDelta  = 0.005;
    adjustedRegion.span.latitudeDelta  = 0.005;
    [_mapView setRegion:adjustedRegion animated:YES];
}

#pragma mark - Text View delegates

-(void)textViewDidBeginEditing:(UITextView *)textView{
    //    plog(@"Did begin editing");
    if (emergencyObjects) { // means user has returned to editing, after hitting 'Next'
        [emergencyObjects moveObject:-emergencyObjects.frame.size.height overTimePeriod:0.75]; // hide display of object types
        [self getTheDescription];
    }
    _typeInfoHere.hidden = YES;
    _commentField.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(self.view.frame.origin.x, -160, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self enableSendButton];
    if ([text isEqualToString:@"\n"]){ [self shutKeyboard:textView]; return NO; }
    return YES;
}

-(void)shutKeyboard:(UITextView *)textView {
    [textView resignFirstResponder];
    [self.view moveObject:0 overTimePeriod:0.5];
}

-(void)textViewDidChange:(UITextView *)textView{
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    //    plog(@"textViewDidEndEditing");
    caption = textView.text;
    //    caption = [caption stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    //    caption = [caption stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    //    plog(@"textViewShouldEndEditing");
    [textView resignFirstResponder];
    //    _backArrow.frame = CGRectOffset(_backArrow.frame, 0, 18);
    return YES;
}

// http://stackoverflow.com/questions/1456120/hiding-the-keyboard-when-losing-focus-on-a-uitextview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    plog(@"Touch");
    //    UITouch *touch = [[event allTouches] anyObject];
    //    if ([_commentField isFirstResponder] && [touch view] != _commentField) {
    //        [_commentField resignFirstResponder];
    //    }
    //    [super touchesBegan:touches withEvent:event];
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
    NSDate *objDate = [dateFormatter dateFromString:IN_strLocalTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *strDateTime   = [dateFormatter stringFromDate:objDate];
    return strDateTime;
}

#pragma mark Facebook

- (IBAction)sendToFBAction:(id)sender {
    shareOnFacebook = !shareOnFacebook;
    plog(@"Facebook sharing: %d", shareOnFacebook);
}

-(void) shareViaFB {
    plog(@"shareViaFB with %d", shareOnFacebook);
    if (!shareOnFacebook) return;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *shareString = [NSString stringWithFormat:@"%@ %@ Link:", @"I'm sharing a selfie as part of Save a Selfie!", _commentField.text];
        [fbPost setInitialText:shareString];
        [fbPost addImage:largerImage];
        [fbPost addURL: [NSURL URLWithString:@"http://www.saveaselfie.org"]];
        [self presentViewController:fbPost animated:YES completion:nil];
        [fbPost setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    plog(@"Post Cancelled");
                    break;
                case SLComposeViewControllerResultDone:
                    plog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else plog(@"isAvailableForServiceType says NO");
}

@end
