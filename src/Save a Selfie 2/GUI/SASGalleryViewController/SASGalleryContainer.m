//
//  SASGalleryContainer.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryContainer.h"

@interface SASGalleryContainer()

@property (nonatomic, strong) NSMutableArray* data;

@end

@implementation SASGalleryContainer



#pragma Object Life Cycle
- (instancetype)init {
    
    if (self = [super init]) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}



- (void )addImage:(UIImage *)image {
    [self.data addObject:image];
}

- (NSInteger) imageCount {
    return [self.data count];
}

- (NSArray *)images {
    return self.data;
}




@end
