//
//  SASMapAnnotationRetriever.h
//  Save a Selfie
//
//  Created by Stephen Fox on 28/05/2015.
//  Copyright (c) 2015 Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol SASMapAnnotationRetrieverDelegate <NSObject>


// @Discussion
//  This method will pass
//  a NSMutableArray with information regarding an annotation.
//
//  @param device: NSMutable array which contains device information.
- (void) sasAnnotationsRetrieved: (NSMutableArray*) devices;

@end



// This class will allow us to fetch/ retrieve MKMapAnnotations.
// This app uses Device.h/.m to wrap up extra information about the device
// i.e image, location etc...
// For more information refer to Device.h.
@interface SASMapAnnotationRetriever : NSObject


@property(assign) id<SASMapAnnotationRetrieverDelegate> delegate;


//  Call this method when you need a newer set of the annotations
//  available from the server.
//  @warning: Can return nil, if there was an error fetching the annotations.
//
//  @Note:
//      This could be improved by trying to catch any errors,
//      while fetching the annotations any forwarding on to
//      any caller.
- (NSMutableArray*) fetchMapAnnotations;


@end
