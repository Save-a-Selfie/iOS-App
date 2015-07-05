//
//  SASUploader.m
//  Save a Selfie
//
//  Created by Stephen Fox on 01/07/2015.
//  Copyright (c) 2015 Stephen Fox & Peter FitzGerald. All rights reserved.
//

#import "SASUploader.h"
#import "UIImage+Resize.h"
#import "UIImage+SASImage.h"
#import "SASNetworkUtilities.h"


@interface SASUploader() <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


@property (strong, nonatomic) UIImage* largeImage;
@property (strong, nonatomic) UIImage* thumbnailImage;

@property (strong, nonatomic) NSMutableData* responseData;

// Boolean flag that will be set to YES, when uploading occurs.
// When uploading finishes or hasn't began this property will be set to NO.
@property(nonatomic, assign) BOOL uploading;

@end

@implementation SASUploader

@synthesize delegate;

@synthesize sasUploadObject;

@synthesize largeImage;
@synthesize thumbnailImage;

@synthesize responseData;
@synthesize uploading;



- (instancetype)initWithSASUploadObject: (SASUploadObject*) object {
    
    if (self == [super init]) {
        self.sasUploadObject = object;
    }
    return self;
}



#pragma mark UploadObject
- (void)upload {
    
    [self setImagesToCorrectSize];

    
    // Construct information for uploading
    NSData *standardImageData = UIImageJPEGRepresentation(self.largeImage, 0.9);
    NSData *thumbnailImageData = UIImageJPEGRepresentation(self.thumbnailImage, 0.9);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    
    NSString *URL = @"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/iPhone.php";
    
    [request setURL:[NSURL URLWithString:URL]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *standardImageString = [standardImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]; // the large (i.e., not thumbnail) image converted to a base-64 string
    NSString *thumbnailImageString = [thumbnailImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]; // the thumbnail image converted to a base-64 string
    
    self.sasUploadObject.caption = [SASNetworkUtilities encodeToPercentEscapeString:self.sasUploadObject.caption]; // The caption for the image – as entered by the user
    
    NSString *parameters = [ NSString stringWithFormat:@"id=%@&typeOfObject=%d&latitude=%f&longitude=%f&location=%@&user=%@&caption=%@&image=%@&thumbnail=%@",
                            self.sasUploadObject.timeStamp,
                            self.sasUploadObject.associatedDevice.type,
                            self.sasUploadObject.coordinates.latitude,
                            self.sasUploadObject.coordinates.longitude,
                            @"",
                            @"",
                            self.sasUploadObject.caption,
                            standardImageString,
                            thumbnailImageString];
    
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
   
    self.responseData = [[NSMutableData alloc] init];
    [self.responseData setLength:0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection) {
        // TODO: ERROR has happened.
    } else {
        // Maybe ignore another press to upload.
    }
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
    NSLog(@"Failed! %@", error);
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sasUploader:didFailWithError:)]) {
        [self.delegate sasUploader:self didFailWithError:error];
    }
}


#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Response received! %@", response);
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"data received - length %lu", (unsigned long)data.length);
    
    [self.responseData appendData:data];
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"finished uploading...");
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sasUploaderDidFinishUploadWithSuccess:)]) {
        [self.delegate sasUploaderDidFinishUploadWithSuccess:self];
    }
}

@end
