//
//  AppCache.m
//  Save a Selfie
//
//  Created by Stephen Fox on 14/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASAppCache.h"

@interface SASAppCache ()

// This is the keys for both images and annotations.
@property (strong, nonatomic) NSMutableArray<SASDevice*> *cachedDevices;
@property (strong, nonatomic) NSMutableDictionary<SASDevice*, UIImage*> *cachedDevicesAndImages;
@property (strong, nonatomic) NSMutableDictionary<SASDevice*, SASAnnotation*> *cachedDeviceAndAnnotations;
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
  _cachedDevices = [[NSMutableArray alloc] init];
  
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


- (void)cacheDevice:(SASDevice *)device {
  if (!self.cachedDevices) {
    self.cachedDevices = [[NSMutableArray alloc] init];
  }
  [self.cachedDevices addObject:device];
}


- (void)cacheImage:(UIImage *)image forDevice:(SASDevice *)device {
  if (!self.cachedDevicesAndImages) {
    self.cachedDevicesAndImages = [[NSMutableDictionary alloc] init];
  }
  
  // If there already exists an object with the exact key,
  // remove it first and then add it back again with
  // the new version of the image.
  if ([self keyExists:device]) {
    [self.cachedDevicesAndImages removeObjectForKey:device];
    [self.cachedDevices removeObject:device];
  }
  [self.cachedDevices addObject:device];
  [self.cachedDevicesAndImages setObject:image forKey:device];
}

- (void)cacheAnnotation:(SASAnnotation *)annotation forDevice:(SASDevice *)device {
  if (!self.cachedDeviceAndAnnotations) {
    self.cachedDeviceAndAnnotations = [[NSMutableDictionary alloc] init];
  }
  if ([self keyExists:device]) {
    [self.cachedDeviceAndAnnotations removeObjectForKey:device];
    [self.cachedDevices removeObject:device];
  }
  [self.cachedDevices addObject:device];
  [self.cachedDeviceAndAnnotations setObject:annotation forKey:device];
}


- (UIImage *)cachedImageForKey:(SASDevice *)key {
  return [self.cachedDevicesAndImages objectForKey:key];
}


- (SASAnnotation *)cachedAnnotationForKey:(SASDevice *)key {
  return [self.cachedDeviceAndAnnotations objectForKey:key];
}

- (NSArray<SASDevice *> *)keys {
  return [self.cachedDevices copy];
}


// Checks to see if the device already within the cache.
- (BOOL) keyExists: (SASDevice*) device {
  if ([self.cachedDevices containsObject:device]) {
    return YES;
  } else {
    return NO;
  }
}
- (void) handleMemoryWarning {
  
}
@end
