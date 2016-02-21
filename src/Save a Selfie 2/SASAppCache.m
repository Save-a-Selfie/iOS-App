//
//  AppCache.m
//  Save a Selfie
//
//  Created by Stephen Fox on 14/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASAppCache.h"
#import "SASAnnotation.h"

@interface SASAppCache ()

// This is the keys for both images and annotations.
@property (strong, nonatomic) NSMutableDictionary<SASDevice*, UIImage*> *cachedDevicesAndImages;
@property (strong, nonatomic) NSMutableDictionary<SASDevice*, SASAnnotation*> *cachedDevicesAndAnnotations;
@end

@implementation SASAppCache

- (instancetype)init {
  self = [super init];
  
  if (!self) {
    return nil;
  }
  // Register for memory warnings.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleMemoryWarning)
                                               name:UIApplicationDidReceiveMemoryWarningNotification
                                             object:nil];
  _cachedDevicesAndImages = [[NSMutableDictionary alloc] init];
  _cachedDevicesAndAnnotations = [[NSMutableDictionary alloc] init];
  
  return self;
}


+ (SASAppCache*) sharedInstance {
  static SASAppCache *sharedInstance;
  static dispatch_once_t token;
  
  dispatch_once(&token, ^(){
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}




- (void)cacheImage:(UIImage *)image forDevice:(SASDevice *)device {
  if (!self.cachedDevicesAndImages) {
    self.cachedDevicesAndImages = [[NSMutableDictionary alloc] init];
  }
  
  // If there already exists an object with the exact key,
  // remove it first and then add it back again with
  // the new version of the image.
  if ([self keyForAnnotationExists:device]) {
    [self.cachedDevicesAndImages removeObjectForKey:device];
  }
  [self.cachedDevicesAndImages setObject:image forKey:device];
}


- (void)cacheAnnotation:(SASAnnotation *)annotation forDevice:(SASDevice *)device {
  if (!self.cachedDevicesAndAnnotations) {
    self.cachedDevicesAndAnnotations = [[NSMutableDictionary alloc] init];
  }
  if ([self keyForAnnotationExists:device]) {
    [self.cachedDevicesAndAnnotations removeObjectForKey:device];
  }
  [self.cachedDevicesAndAnnotations setObject:annotation forKey:device];
}


- (UIImage *)cachedImageForKey:(SASDevice *)key {
  return [self.cachedDevicesAndImages objectForKey:key];
}

- (SASAnnotation *) cachedAnnotationForKey:(SASDevice *) key {
  return [self.cachedDevicesAndAnnotations objectForKey:key];
}


- (NSArray<SASDevice *> *)keysForImages {
  return [[self.cachedDevicesAndImages allKeys] copy];
}

- (NSArray<SASDevice *> *)keysForAnnotations {
  return [[self.cachedDevicesAndAnnotations allKeys] copy];
}

// Return a copy of the key value pairs for annotations.
- (NSDictionary<SASDevice*, SASAnnotation*>*) annotationKeyValuePairs {
  return [self.cachedDevicesAndAnnotations copy];
}


- (NSDictionary<SASDevice*, UIImage*>*) imageKeyValuePairs {
  return [self.cachedDevicesAndImages copy];
}



// Checks to see if the device already within the cache for images.
- (BOOL) keyForImageExists: (SASDevice*) device {
  NSArray *imageKeys = [self.cachedDevicesAndImages allKeys];
  if ([imageKeys containsObject:device]) {
    return YES;
  } else {
    return NO;
  }
}


// // Checks to see if the device already within the cache for annotations.
- (BOOL) keyForAnnotationExists: (SASDevice*) device {
  NSArray *annotationKeys = [self.cachedDevicesAndAnnotations allKeys];
  if ([annotationKeys containsObject:device]) {
    return YES;
  } else {
    return NO;
  }
}
- (void) handleMemoryWarning {
  
}
@end
