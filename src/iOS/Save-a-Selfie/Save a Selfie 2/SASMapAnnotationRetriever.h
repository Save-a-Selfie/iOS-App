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
//  This method will be pass
//  a NSMutableArray with information regarding an annotation.
- (void) sasAnnotatonsRetrieved: (NSMutableArray*) device;

@end

@interface SASMapAnnotationRetriever : NSObject

@property(assign) id<SASMapAnnotationRetrieverDelegate> delegate;

@end
