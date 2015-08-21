//
//  SASGalleryContainer.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryContainer.h"
#import "SASLocation.h"

@interface SASGalleryContainer()

@property (nonatomic, strong) NSMutableDictionary *data;


@end

@implementation SASGalleryContainer



#pragma Object Life Cycle
- (instancetype)init {
    
    if (self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];

    }
    return self;
}



- (void)addImage:(UIImage *)image forDevice:(SASDevice *)device {
    [self.data setObject:image forKey:device];
}


- (NSInteger) deviceCount {
    return [self.data count];
}


- (UIImage *) imageForDevice:(SASDevice *) device {
    UIImage* image = [self.data objectForKey:device];

    return image;
}


- (void) clear {
    [self.data removeAllObjects];
}







@end