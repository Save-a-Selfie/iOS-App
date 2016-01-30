//
//  SASNetworkQuery.m
//  Save a Selfie
//
//  Created by Stephen Fox on 29/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASNetworkQuery.h"

@implementation SASNetworkQuery

+ (SASNetworkQuery*) queryWithType:(SASNetworkQueryType) type {
  SASNetworkQuery *query = [[SASNetworkQuery alloc] init];
  query.type = type;
  return query;
}
@end
