//
//  ParseFactory.h
//  Save a Selfie
//
//  Created by Stephen Fox on 24/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse.h>
#import "SASUploadObject.h"

/**
 Use the Parse factory for resources of components, mostly PFObjects
 that are required from the Parse framework.*/
@interface ParseFactory : NSObject

/**
 Reference the sharedInstance property to message for 
 Parse componenets througout the application.
 */
+ (ParseFactory*) sharedInstance;


/**
 Creates a PFObject (basically how the backend expects the information)
 which will have the appropriate fields set according to their
 respective attributes withing the given SASUploadObject.
 
 @param uploadObject The object that will be used to 
                     create a PFObject, which can 
                     then be uploaded to the backend.

 @return A PFObject will be returned will all its attributes
         set accrording to the passed SASUploadObject.
         IF any of the SASUploadObject fields are nil,
         the PFObject will have those fields set to [NSNull null].
 */
- (PFObject*) createUploadObject:(SASUploadObject*) uploadObject;


@end
