//
//  SASUploader.m
//  Save a Selfie
//
//  Created by Stephen Fox on 01/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASUploader.h"
#import "UIImage+Resize.h"
#import "UIImage+SASImage.h"


@interface SASUploader() <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


@property (strong, nonatomic) UIImage* largeImage;
@property (strong, nonatomic) UIImage* thumbnailImage;

@property (strong, nonatomic) NSData *largeImageData;
@property (strong, nonatomic) NSData *thumbnailImageData;

@property (strong, nonatomic) NSMutableData* responseData;

 

@end




@implementation SASUploader

@synthesize largeImage;
@synthesize thumbnailImage;

@synthesize largeImageData;
@synthesize thumbnailImageData;

@synthesize responseData;

@synthesize sasUploadObject;



- (instancetype)initWithSASUploadObject: (SASUploadObject*) object {
    
    if (self == [super init]) {
        self.sasUploadObject = object;
    }
    return self;
}



#pragma mark UploadObject
- (void)upload {
    
    [self setImagesToCorrectSize];
    
    
    if(self.largeImageData == nil) {
        self.largeImageData = UIImageJPEGRepresentation(self.largeImage, 0.9);
    }
    if(self.thumbnailImage == nil) {
        self.largeImageData = UIImageJPEGRepresentation(self.thumbnailImage, 0.9);
    }
    
    
    // construct information for uploading
    NSData *imageData = UIImageJPEGRepresentation(self.largeImage, 0.9);
    NSData *imageDataTh = UIImageJPEGRepresentation(self.thumbnailImage, 0.9);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    
    NSString *URL = @"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/iPhone.php";
    
    [request setURL:[NSURL URLWithString:URL]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]; // the large (i.e., not thumbnail) image converted to a base-64 string
    NSString *imageStrTh = [imageDataTh base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]; // the thumbnail image converted to a base-64 string
    
    self.sasUploadObject.description = [self encodeToPercentEscapeString:self.sasUploadObject.description]; // the caption for the image – as entered by the user
    
    NSString *parameters = [ NSString stringWithFormat:@"id=%@&typeOfObject=%d&latitude=%f&longitude=%f&location=%@&user=%@&caption=%@&image=%@&thumbnail=%@",
                            self.sasUploadObject.timeStamp,
                            self.sasUploadObject.associatedDevice.type,
                            self.sasUploadObject.coordinates.latitude,
                            self.sasUploadObject.coordinates.longitude,
                            @"",
                            @"",
                            self.sasUploadObject.description,
                            imageStr,
                            imageStrTh];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSLog(@"URL: %@?%@", URL, parameters);
    
   
    responseData = [[NSMutableData alloc] init];
    [responseData setLength:0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}


- (void) setImagesToCorrectSize {
    
    // TODO: Clean this up. Ideally all this resizing should be done within
    // a UIImage caterory.
    self.largeImage = self.sasUploadObject.image;
    
    
    float maxWidth = 400, thumbSize = 150;
    float ratio = maxWidth / self.largeImage.size.width;
    float height, width, minDim, tWidth, tHeight;
    
    if (ratio >= 1.0) {
        width = self.largeImage.size.width;
        height = self.largeImage.size.height;
    }
    else { width = maxWidth;
        height = self.largeImage.size.height * ratio;
    }
    
    // Large Image
    self.largeImage = [self.sasUploadObject.image resizedImage:CGSizeMake(width, height) interpolationQuality:kCGInterpolationHigh];
    
    
    // Thumbnail Image
    minDim = height < width ? height : width;
    ratio = thumbSize / minDim; tWidth = width * ratio; tHeight = height * ratio;
    
    self.thumbnailImage = [self.largeImage resizedImage:CGSizeMake(tWidth, tHeight) interpolationQuality:kCGInterpolationHigh];
    
    // Add watermarks.
    self.largeImage = [UIImage doubleMerge:self.largeImage
                                 withImage:[UIImage imageNamed:@"Order of Malta 70px high"]
                                       atX:20
                                      andY:20
                              withStrength:1.0
                                  andImage:[UIImage imageNamed:@"Code for ireland logo transparent85rounded"]
                                      atX2:width - 105
                                     andY2:height - 70
                                  strength:1.0];
    

    
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed! %@", error.description);
}


#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Response received! %@", response);
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"data received - length %lu", (unsigned long)data.length);
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"finished uploading...");
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

@end
