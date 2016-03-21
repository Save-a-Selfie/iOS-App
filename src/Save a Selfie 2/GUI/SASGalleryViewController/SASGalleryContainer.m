//
//  SASGalleryContainer.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryContainer.h"
#import "SASLocation.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"

@interface SASGalleryContainer()

@property (nonatomic, strong) NSMutableDictionary<UIImage*, SASDevice*> *data;


@end

@implementation SASGalleryContainer



#pragma Object Life Cycle
- (instancetype)init {
    
    if (self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];

    }
    return self;
}



- (void) addDevice:(SASDevice *) device forImage:(UIImage *) image {
    [self.data setObject:device forKey:[image copy]];
}


- (NSInteger) deviceCount {
    return [self.data count];
}


- (SASDevice *) deviceForImage:(UIImage *)image {
    SASDevice* device = [self.data objectForKey:image];
    return device;
}

- (NSArray<UIImage *> *)keys {
  return [self.data allKeys];
}
- (void) clear {
    [self.data removeAllObjects];
}







@end