//
//  AppCache.h
//  Save a Selfie
//
//  Created by Stephen Fox on 14/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"
#import "SASAnnotation.h"


/**
 This is an internal cache clients can use to access
 resources which are used globally. The lifetime of the cache
 is dicatated by the avalable system resources.
 Once the app is terminated resources will be freed.*/
@interface SASAppCache : NSObject


+ (nonnull SASAppCache*) sharedInstance;


- (void) cacheDevice:(nonnull SASDevice*) device;


- (void) cacheImage:(nonnull UIImage *) image forDevice:(nonnull SASDevice*) device;


- (void) cacheAnnotation:(nonnull SASAnnotation*) annotation forDevice:(nonnull SASDevice*) device;


- (nullable UIImage*) cachedImageForKey:(nonnull SASDevice*) key;

- (nullable SASAnnotation*) cachedAnnotationForKey:(nonnull SASDevice*) key;

- (nullable NSArray<SASDevice*>*) keys;

@end
