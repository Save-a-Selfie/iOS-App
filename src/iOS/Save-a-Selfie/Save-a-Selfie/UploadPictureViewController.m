//
//  UploadPictureViewController.m
//  Save-a-Selfie
//
//  Created by Nadja Deininger on 12/05/14.
//  Copyright (c) 2014 Code for All Ireland. All rights reserved.
//

#import "UploadPictureViewController.h"

@interface UploadPictureViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;

@end

@implementation UploadPictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.hidden = YES;
    _commentField.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)handleSelectClick:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Select image source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo", @"Choose from existing", nil];
    as.tag = 1;
    [as showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
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
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:_picker animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera could not be found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)useCameraRoll {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:_picker animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Photo library could not be found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self.picker dismissViewControllerAnimated:NO completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *imageToSave;
    if([info objectForKey:UIImagePickerControllerEditedImage]) {
        imageToSave = info[UIImagePickerControllerEditedImage];
    }
    else if([info objectForKey:UIImagePickerControllerOriginalImage]) {
        imageToSave = info[UIImagePickerControllerOriginalImage];
    }
    else {UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Selected image could not be found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    [_imageView setImage:imageToSave];
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) addLocationDataToImage {
    
    if(nil == _locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    [_locationManager setDelegate:self];
    
    if([CLLocationManager locationServicesEnabled]) {
        _haveCurrentLocation = NO;
        [_locationManager startUpdatingLocation];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services disabled" message:@"For now, we need your location to place your selfie on the map. Would you like to turn on Location Services?" delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles:@"Yes",nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 1) {
        
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if(!_haveCurrentLocation) {
        CLLocation *newLocation = [locations lastObject];
        _currentLocation = newLocation.coordinate;
    
        [self sendImageToServer:_imageView.image];
        _haveCurrentLocation = YES;
    }
    
}

- (void) sendImageToServer:(UIImage *) image {
    NSData *imageData = UIImagePNGRepresentation(image);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:@"http://gunfire.becquerel.org/entries/create/"]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSData *thumbnailData = UIImagePNGRepresentation([self createThumbnail:image]);
    NSString *thumbnailStr = [thumbnailData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"latitude=37.00000", @"&longitude=-127.0000", @"&uploadedby=", @"", @"&comment=", @"", @"&image=", thumbnailStr, @"&thumbnail=", thumbnailStr, nil];
    
    NSString *body = [parameters componentsJoinedByString:@""];
    
                        
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

    [_activityIndicator startAnimating];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload error" message:@"An error occurred establishing the HTTP connection. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [_locationManager stopUpdatingLocation];
    
}

- (IBAction)didTouchButton:(id)sender {
    [self addLocationDataToImage];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(error.description);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_activityIndicator stopAnimating];
    
}

- (UIImage *) createThumbnail: (UIImage *) original
{
    CGSize newSize = CGSizeMake(100, 100);

    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnail;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
