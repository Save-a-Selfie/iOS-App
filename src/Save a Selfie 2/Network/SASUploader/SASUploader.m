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
#import "SASUtilities.h"


@interface SASUploader() <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


@property (strong, nonatomic) NSMutableData* responseData;

// Boolean flag that will be set to YES, when uploading occurs.
// When uploading finishes or hasn't began this property will be set to NO.
@property(nonatomic, assign) BOOL uploading;

@end

@implementation SASUploader

#pragma Object Life Cycle
- (instancetype)initWithSASUploadObject: (SASUploadObject <SASVerifiedUploadObject>*) object {
    
    if (self = [super init]) {
        _sasUploadObject = object;
    }
    return self;
}



#pragma mark UploadObject
- (void)upload {
    
    // Make sure we have a valid object
    // to upload.
    BOOL canProceedToUpload = [self validateSASUploadObject];
    
    
    if(canProceedToUpload) {
        
        NSArray *images = [UIImage createLargeImageAndThumbnailFromSource:self.sasUploadObject.image];
        UIImage *standardImage = images[0];
        UIImage *thumbnailImage = images[1];
        
        // Construct information for uploading
        NSData *standardImageData = UIImageJPEGRepresentation(standardImage, 1.0);
        NSData *thumbnailImageData = UIImageJPEGRepresentation(thumbnailImage, 1.0);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        
        NSString *URL = @"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/iPhone.php";
        
        [request setURL:[NSURL URLWithString:URL]];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        NSString *standardImageString = [standardImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]; // the large (i.e., not thumbnail) image converted to a base-64 string
        NSString *thumbnailImageString = [thumbnailImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]; // the thumbnail image converted to a base-64 string
        
        self.sasUploadObject.caption = [SASNetworkUtilities encodeToPercentEscapeString:self.sasUploadObject.caption]; // The caption for the image – as entered by the user
        
        
        self.sasUploadObject.identifier = [NSString stringWithFormat:@"%@%@", self.sasUploadObject.timeStamp, [SASUtilities generateRandomString:4]];
        
        
        NSString *parameters = [ NSString stringWithFormat:@"id=%@&typeOfObject=%d&latitude=%f&longitude=%f&location=%@&user=%@&caption=%@&image=%@&thumbnail=%@&deviceID=%@&devType=iOS", self.sasUploadObject.identifier, self.sasUploadObject.associatedDevice.type, self.sasUploadObject.coordinates.latitude, self.sasUploadObject.coordinates.longitude, @"", @"", self.sasUploadObject.caption, standardImageString, thumbnailImageString, self.sasUploadObject.UUID];
        
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        
        if(connection) {
            
            self.responseData = [[NSMutableData alloc] init];
            [self.responseData setLength:0];
            
            // Message the delegate that we have our connection and have begun uploading.
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sasUploaderDidBeginUploading:)]) {
                [self.delegate sasUploaderDidBeginUploading:self];
            }
            
        }
        
    }
}



// @return YES: If the object is ready to be uploaded.
// @return NO: IF the object is not ready to be uploaded.

// This method will also call the delegate.
- (BOOL) validateSASUploadObject {
    
    if(![self.sasUploadObject captionHasBeenSet]) {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sasUploader:invalidObjectWithResponse:)]) {
            [self.delegate sasUploader: self.sasUploadObject invalidObjectWithResponse:SASUploadInvalidObjectCaption];
        }
        return NO;
    }
    if (![self.sasUploadObject deviceHasBeenSet]) {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sasUploader:invalidObjectWithResponse:)]) {
            [self.delegate sasUploader:self.sasUploadObject invalidObjectWithResponse:SASUploadInvalidObjectDeviceType];
        }
        return NO;
    }
    if(![self.sasUploadObject coordinatesHaveBeenSet]) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sasUploader:invalidObjectWithResponse:)]) {
            [self.delegate sasUploader:self.sasUploadObject invalidObjectWithResponse:SASUploadInvalidObjectCoordinates];
        }
        return NO;
    }
    else {
        return YES;
    }
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
