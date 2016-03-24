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
#import "Filterable.h"

/**
 This is an internal cache clients can use to access
 resources which are used globally. The lifetime of the cache
 is dicatated by the avalable system resources.
 Once the app is terminated resources will be freed.
 */
@interface SASAppCache : NSObject


+ (nonnull SASAppCache*) sharedInstance;


/**
 Caches a key(SASDevice) for a value(UIImage) within the app cache.
 If an SASDevice already exist as a key for a UIImage then it will
 be overwritten an the new key will be used.
 
 @param image  The image to cache.
 @param device The key to access the image.
 */
- (void) cacheImage:(nonnull UIImage *) image forDevice:(nonnull SASDevice*) device;

/**
 Caches a key(SASDevice) for a value(SASAnnotation) within the app cache.
 If an SASDevice already exist as a key for a SASAnnotation then it will
 be overwritten an the new key will be used.
 
 @param annotation The annotation to cache.
 @param device The key to access the annotation.
 */
- (void) cacheAnnotation:(nonnull SASAnnotation*) annotation forDevice:(nonnull SASDevice*) device;



- (nullable NSArray<SASAnnotation*>*) filterAnnotation:(nonnull NSArray<SASAnnotation*>*) annotations
                                             forFilter:(nonnull id<Filterable>) filter
                                        withDeviceType:(SASDeviceType) type;


- (nullable UIImage*) cachedImageForKey:(nonnull SASDevice*) key;


- (nullable SASAnnotation*) cachedAnnotationForKey:(nonnull SASDevice*) key;

- (nullable NSArray<SASDevice*>*) keysForImages;

- (nullable NSArray<SASDevice*>*) keysForAnnotations;

- (nullable SASDevice *)objectForAnnotationKey:(nonnull SASAnnotation*) annotation;

- (nullable NSDictionary<SASDevice*, UIImage*>*) imageKeyValuePairs;

- (nullable NSDictionary<SASDevice*, SASAnnotation*>*) annotationKeyValuePairs;

// Returns the number of items cached.
- (NSUInteger) cachedAmount;
@end
