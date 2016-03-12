//
//  SASNetworkQuery.m
//  Save a Selfie
//
//  Created by Stephen Fox on 29/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASNetworkQuery.h"

@interface SASNetworkQuery ()

@property (assign, nonatomic) CLLocationCoordinate2D coordinates;
@property (strong, nonatomic) NSString *imageArg;
@end

@implementation SASNetworkQuery

+ (SASNetworkQuery*) queryWithType:(SASNetworkQueryType) type {
  SASNetworkQuery *query = [[SASNetworkQuery alloc] init];
  query.type = type;
  return query;
}


- (void)setImageArguments:(NSString *)image {
  _imageArg = image;
}

- (NSString *)imageArguments {
  return [self.imageArg copy];
}

- (void)setLocationArguments:(CLLocationCoordinate2D) coordinates {
  _coordinates = coordinates;
}

- (CLLocationCoordinate2D)coordinates {
  return _coordinates;
}


@end
