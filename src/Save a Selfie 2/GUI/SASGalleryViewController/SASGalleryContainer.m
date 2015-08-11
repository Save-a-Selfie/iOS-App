//
//  SASGalleryContainer.m
//  Save a Selfie
//
//  Created by Stephen Fox on 04/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASGalleryContainer.h"
#import "SASLocation.h"

@interface SASGalleryContainer() <SASLocationDelegate> {
    NSUInteger dictionaryCount;
}

@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) SASLocation *sasLocation;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;

@end

@implementation SASGalleryContainer



#pragma Object Life Cycle
- (instancetype)init {
    
    if (self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];
        _filterType = SASGalleryFilterTypeDefault;
        dictionaryCount = 0;
    }
    return self;
}



- (void)addImage:(UIImage *)image forDevice:(SASDevice *)device {
    [self.data setObject:image forKey:device];
    dictionaryCount++;
}


- (NSInteger) deviceCount {
    return dictionaryCount;
}

- (NSArray *)images {
    
    NSArray* keys = [self.data allKeys];
    NSLog(@"%@", keys);
    NSMutableArray *images = [NSMutableArray new];
    
    if (self.filterType == SASGalleryFilterTypeDefault) {
        for (int i = 0; i < keys.count; i++) {
            [images addObject:[self.data objectForKey:keys[i]]];
        }
        return images;
        
    } else {
        return nil;
    }
}




- (void)setFilterType:(SASGalleryFilterType) filterType {
    _filterType = filterType;
    [self updateArrayForFilterType:_filterType];
}


#pragma Array Structure Changes
- (void) updateArrayForFilterType:(SASGalleryFilterType) filterType {
    
    switch (filterType) {
        case SASGalleryFilterTypeLocation:
            [self updateArrayForLocationFilter];
            break;
            
        default:
            break;
    }
}

- (void) updateArrayForLocationFilter {
    if(!self.sasLocation) {
        self.sasLocation = [[SASLocation alloc] init];
        self.sasLocation.delegate = self;
        [self.sasLocation startUpdatingUsersLocation];
    }
    
    self.userLocation = [self.sasLocation currentUserLocation];
    
    // Dictioanry is set with SASDevices as keys and their distance
    // from the user's location as the object.
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    
    CLLocation *usersLocation;
    CLLocation *deviceLocation;
    CLLocationDistance distance;

    for (SASDevice *device in self.data) {
        
        // Device location
        deviceLocation = [[CLLocation alloc] initWithLatitude:device.deviceLocation.latitude
                                                   longitude:device.deviceLocation.longitude];
        
        // Users location.
        usersLocation = [[CLLocation alloc] initWithLatitude:self.userLocation.latitude
                                                    longitude:self.userLocation.longitude];
        
        distance = [usersLocation distanceFromLocation:deviceLocation];
        
        // As CLLocationDistance is just a typedef of double
        // we shall wrap it up as an NSNumber so we can treat
        // it as an object.
        NSNumber *distanceWrapper = [[NSNumber alloc] initWithDouble:distance];
        
        [dataDict setObject:distanceWrapper forKey:device];
    }
    

    
    
}

- (void) sortArrayByDeviceDistance:(NSDictionary*) dictionary  {
      
    
    
}


- (void) sasLocation:(SASLocation *)sasLocation locationDidUpdate:(CLLocationCoordinate2D)location {
}


@end
