//
//  SASNetworkQuery.h
//  Save a Selfie
//
//  Created by Stephen Fox on 29/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SASNetworkQueryType) {
  SASNetworkQueryTypeAll
};

/**
 An object that encapsulate some way of 
 requesting information from the server.
*/
@interface SASNetworkQuery : NSObject

@property (nonatomic, assign) SASNetworkQueryType type;


/**
 Returns a new instance of SASNetworkQuery for a specific query
 type.
 */
+ (instancetype) queryWithType: (SASNetworkQueryType) type;

@end
