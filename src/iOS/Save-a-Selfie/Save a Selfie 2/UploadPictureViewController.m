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
#import "FBProtocols.h"
#import "FacebookVC.h"
#import <FacebookSDK/FBRequest.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PopupImage.h"
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
CLLocationManager *locationManager;
CLLocationCoordinate2D currentLocation;
extern NSString *const applicationWillEnterForeground;
extern NSString *const objectChosen;
extern NSString *const handledFBResponse;
extern int chosenObject;
extern BOOL FBLoggedIn;
extern NSString *facebookUsername;
extern UIFont *customFont, *customFontSmaller;

// To do
//
// Message after FB upload
// Back button getting hidden at times
// Allow user to cancel before uploading
// Save while quitting
// 'Close' button on images in website
// replace UIAlertView with AlertBox everywhere
// need to sort out compiler warnings

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
    
    // dull out Send button
    [self makeSendButtonGrey];
    
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
    self.tabBarController.delegate = self;
    if (!alert) {
        [[NSBundle mainBundle] loadNibNamed:@"AlertBox" owner:self options:nil];
        alert = [[AlertBox alloc] initWithFrame:CGRectMake(20, 150, 260, 90)];
        alert.center = self.view.center;
    }
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

-(void) clearPermissionsBox { // called when returning from outside app
    if (permissionsBox) [permissionsBox removeFromSuperview]; permissionsBox = nil;
    //	[locationManager startUpdatingLocation];
}

-(void)makeSendButtonGrey { // turns it grey for some reason
    _sendButton.enabled = NO; // initially disabled – until user types some sort of description in commentField
    _sendButton.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [_sendButton setTitle:@"Next" forState:UIControlStateNormal];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)OKAction:(id)sender { // performs set-ups on labels, etc.
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
    [_littleGuy moveObject:300 overTimePeriod:0.5];
    [_multipurposeLabel changeViewWidth:screenWidth - 52 atX:9999 centreIt:YES duration:0];
    [_multilabelBackground changeViewWidth:screenWidth - 40 atX:9999 centreIt:YES duration:0];
    [_multipurposeLabel moveObject:screenHeight + 100 overTimePeriod:0];
    _multipurposeLabel.hidden = NO;
    _multipurposeLabel.font = customFont;
    [_multipurposeLabel moveObject:370 overTimePeriod:0.5];
    [_multilabelBackground moveObject:screenHeight + 100 overTimePeriod:0];
    _multilabelBackground.hidden = NO;
    plog(@"OKAction 2");
    [_multilabelBackground moveObject:364 overTimePeriod:0.5];
    _multipurposeLabel.text = @"Tap 'Photo' below to take or retrieve a photo, or 'Locate' to find a device and see photos, or 'Info' to learn about the project";
    float newSendX = _multilabelBackground.frame.origin.x + _multilabelBackground.frame.size.width - _sendButton.frame.size.width;
    [_sendButton changeViewWidth:_sendButton.frame.size.width atX:newSendX centreIt:NO duration:0];
    _backArrow.frame = CGRectMake(_multilabelBackground.frame.origin.x, _littleGuy.frame.origin.y + 30, _backArrow.frame.size.width, _backArrow.frame.size.height);
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

#pragma mark - Navigation

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex != 0) { firstAppearance = YES; return; }
    if (!firstAppearance) {
        [self showActionSheet:self];
    } else firstAppearance = NO;
}

- (IBAction)backArrowAction:(id)sender {
    [self swapViewControllers];
}

-(void)swapViewControllers {
    // if logged into Facebook, or if user has chosen to skip login, change to 'proper' first view controller
    //    ((UITabBarController*)self.window.rootViewController).selectedViewController;
    //	plog(@"Root: %@", self.window.rootViewController);
    UITabBarController *tabController = (UITabBarController *)self.tabBarController;
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:tabController.viewControllers];
    plog(@"mArray: %@", mArray);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FacebookVC *FBVC = [storyboard instantiateViewControllerWithIdentifier:@"FacebookVC"];
    [mArray replaceObjectAtIndex:0 withObject:FBVC];
    [tabController setViewControllers:mArray animated:NO];
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
        [alert fillAlertBox:@"Problem" button1Text:@"Selected image could not be found" button2Text:nil action1:@selector(removeAlert) action2:nil calledFrom:self opacity:0.85 centreText:YES];
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
        _typeInfoHere.hidden = YES;
        _commentField.alpha = 1;
        _commentField.editable = NO;
        [alert fillAlertBox:@"Photo already uploaded" button1Text:@"Replace" button2Text:@"Don't replace" action1:@selector(replacePhoto) action2:@selector(doNotProceed) calledFrom:self opacity:0.85 centreText:YES];
        [alert addBoxToView:self.view withOrientation:0];
    } else {
        _typeInfoHere.hidden = NO; _commentField.alpha = 0.5;
        [self getTheDescription];
        _commentField.text = @""; [self makeSendButtonGrey];
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
    [self makeSendButtonGrey];
    [self getTheDescription];
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
-(void)getTheDescription {
    // now want the description; when the user has typed something in the description field then the 'Next' button will be enabled, allowing the user to proceed to the final stage
    [_littleGuy moveObject:165 overTimePeriod:0.5];
    [_multipurposeLabel moveObject:231 overTimePeriod:0.85];
    [_multilabelBackground moveObject:225 overTimePeriod:0.85];
    _commentField.hidden = NO;
    _commentField.editable = YES;
    _typeInfoHere.hidden = NO;
    _multipurposeLabel.font = customFont;
    //    _backArrow.frame = CGRectOffset(_backArrow.frame, 0, -18);
    [self showInstructions:@"Before uploading, please add some useful information below – name of location, where the device is in the location, etc."];
    // fade out the photo, as the instructions have come up in front of it
    [UIView animateWithDuration:5.0 animations:^{ _imageView.alpha = 0.5; }];
    FBLoggedIn = YES;
    if (FBLoggedIn) {
        if (!commentFieldAltered) _commentField.frame = CGRectMake(_commentField.frame.origin.x, _commentField.frame.origin.y, _commentField.frame.size.width, _commentField.frame.size.height - 50);
        commentFieldAltered = YES;
        _sendToFBButton.frame = CGRectMake(_commentField.frame.origin.x, _sendToFBButton.frame.origin.y, _sendToFBButton.frame.size.width, _sendToFBButton.frame.size.height);
        _sendToFBLabel.frame = CGRectMake(_sendToFBLabel.frame.origin.x, _sendToFBButton.frame.origin.y + _sendToFBButton.frame.size.height, _sendToFBLabel.frame.size.width, _sendToFBLabel.frame.size.height);
        [_sendToFBButton moveObject:screenHeight - 90 overTimePeriod:0.5];
        [_sendToFBLabel moveObject:screenHeight - 90 overTimePeriod:0.5];
    }
}

#pragma mark Send image to server

- (IBAction)sendIt:(id)sender { // not ready to send quite yet: find out which type of object (AED, life-ring, etc.)
    [self shutKeyboard:_commentField];
    // move little guy etc. down
    [_littleGuy moveObject:260 overTimePeriod:0.5];
    [_multipurposeLabel moveObject:330 overTimePeriod:0.5];
    [_multilabelBackground moveObject:324 overTimePeriod:0.5];
    _multipurposeLabel.text = @"Please select one of the devices above, corresponding to what is in the photo.";
    
    [_multipurposeLabel changeViewWidth:_multipurposeLabel.frame.size.width * 0.85 atX:screenWidth * 0.25 centreIt:NO duration:0.5];
    [_multilabelBackground changeViewWidth:_multilabelBackground.frame.size.width * 0.85 atX:screenWidth * 0.25 - 6 centreIt:NO duration:0.5];
    
    // display set of four objects
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
    } else [self OKAction:self];
}

- (void) sendImageToServer {
    
    // have got the photo, the description, and know what type of emergency object it is – ready to upload
    
    // first, resize image
    UIImage *image = _imageView.image;
    plog(@"resizing...");
    float maxWidth = 400, thumbSize = 150;
    float ratio = maxWidth / image.size.width;
    float height, width, minDim, tWidth, tHeight;
    if (ratio >= 1.0) { width = image.size.width; height = image.size.height; }
    else { width = maxWidth; height = image.size.height * ratio; }
    plog(@"resizing to %f, %f (%f, %f, %f)", width, height, ratio, image.size.width, image.size.height);
    largerImage = [image resizedImage:CGSizeMake(width, height) interpolationQuality:kCGInterpolationHigh];
    
    // generate thumbnail
    minDim = height < width ? height : width;
    ratio = thumbSize / minDim; tWidth = width * ratio; tHeight = height * ratio;
    plog(@"resizing to %f, %f", tWidth, tHeight);
    UIImage *thumbnail = [largerImage resizedImage:CGSizeMake(tWidth, tHeight) interpolationQuality:kCGInterpolationHigh];
    
    // add 'watermarks'
    largerImage = [self doubleMerge:largerImage withImage:[UIImage imageNamed:@"Order of Malta Logo 50px high"] atX:20 andY:20 withStrength:1.0 andImage:[UIImage imageNamed:@"Code for ireland logo transparent85"] atX2:width - 95 andY2:height - 60 strength:1.0];
    
    _imageView.alpha = 0.25; // fade photo
    
    // construct information for uploading
    NSData *imageData = UIImageJPEGRepresentation(largerImage, 0.9);
    NSData *imageDataTh = UIImageJPEGRepresentation(thumbnail, 0.9);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:@"http://iculture.info/saveaselfie/wp-content/themes/magazine-child/iPhone.php"]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *imageStrTh = [imageDataTh base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    caption = [self encodeToPercentEscapeString:caption];
    NSString *user = [self encodeToPercentEscapeString:facebookUsername];
    plog(@"caption is %@", caption);
    NSString *parameters = [ NSString stringWithFormat:@"id=%@&typeOfObject=%d&latitude=%f&longitude=%f&location=%@&user=%@&caption=%@&image=%@&thumbnail=%@", photoID, chosenObject, photoLocation.coordinate.latitude, photoLocation.coordinate.longitude, @"", user, caption, imageStr, imageStrTh];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    plog(@"parameters...%@", parameters);
    
    [_activityIndicator startAnimating];
    responseData = [[NSMutableData alloc] init];
    [responseData setLength:0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload error" message:@"An error occurred establishing the HTTP connection. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else uploading = YES;
    
    [locationManager stopUpdatingLocation];
    
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
    plog(error.description);
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
    _sendButton.tintColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
    _sendButton.enabled = NO;
    [_sendButton setTitle:@"Next" forState:UIControlStateNormal];
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
    
    // save ID and caption to user's data file - to avoid duplicates
    [[NSUserDefaults standardUserDefaults] setValue:caption forKey:photoID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    NSString *existingCaption = [[NSUserDefaults standardUserDefaults] valueForKey:photoID];
}

#pragma mark Location services

-(void)permissionsProblem:(NSString *)message {
    [[NSBundle mainBundle] loadNibNamed:@"AlertBox" owner:self options:nil];
    int boxHeight = 240;
    if (!permissionsBox) permissionsBox = [[AlertBox alloc] initWithFrame:CGRectMake(70, (screenHeight - boxHeight) * 0.5, 220, boxHeight)];
    [permissionsBox fillAlertBox:message button1Text:nil button2Text:nil action1:nil action2:nil calledFrom:self opacity:0.85 centreText:NO];
    permissionsBox.center = self.view.center;
    //	[self addSubview:permissionsBox];
    [permissionsBox addBoxToView:self.view withOrientation:0];
}

- (void) startLocating {
    if(nil == locationManager) { locationManager = [[CLLocationManager alloc] init]; }
    [locationManager setDelegate:self];
    if([CLLocationManager locationServicesEnabled]) {
        plog(@"location services enabled");
        if ([self checkPermissions]) [locationManager startUpdatingLocation];
    } else {
        SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
        if ([locationManager respondsToSelector:requestSelector]) { // requestWhenInUseAuthorization only works from iOS 8
            [locationManager performSelector:requestSelector withObject:NULL];
            [self checkPermissions];
        } else [locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    plog(@"didChangeAuthorizationStatus");
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) [locationManager startUpdatingLocation];
}

-(BOOL)checkPermissions {
    BOOL allGrand = NO;
    plog(@"checking permissions");
    if (permissionsBox) [permissionsBox removeFromSuperview]; // get rid of any existing permissions box blocking access to camera etc.
    if([CLLocationManager locationServicesEnabled]){
        plog(@"Location Services Enabled");
        switch([CLLocationManager authorizationStatus]){
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                plog(@"We have access to location services");
                allGrand = YES;
                break;
            case kCLAuthorizationStatusDenied:
                [self permissionsProblem:@"Please enable location services for this app. You need to launch the iPhone Settings app to do this (in it, go to Privacy > Location Services, scroll down until you see Save a Selfie and switch it to 'On'). You'll have to go out of this app temporarily now, using the 'Home' button below this screen."];
                plog(@"Location services denied by user");
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
        [self permissionsProblem:@"Please enable location services on your phone. You need to launch the iPhone Settings app to do this (in it, go to Privacy > Location Services and switch it to 'On'). You'll have to go out of this app temporarily now, using the 'Home' button below this screen."];
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
    _sendButton.enabled = YES;
    _sendButton.tintColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
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
    if (!shareOnFacebook) return;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *shareString = [NSString stringWithFormat:@"%@ %@ Link:", @"I'm sharing a selfie as part of Save a Selfie!", _commentField.text];
        [fbPost setInitialText:shareString];
        [fbPost addImage:largerImage];
        [fbPost addURL: [NSURL URLWithString:@"http://www.iculture.info/saveaselfie"]];
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
