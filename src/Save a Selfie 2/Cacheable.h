//
//  Cacheable.h
//  Save a Selfie
//
//  Created by Stephen Fox on 15/02/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 This protocol is typically implemented when an
 object wants to provide they're own custom caching
 implementation when given the choice.
*/
@protocol Cacheable <NSObject>

- (void) cacheObjects: (NSArray<NSObject*>*) objects;

@end