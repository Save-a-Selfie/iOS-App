//
//  SASGalleryContainer.h
//  Save a Selfie
//
//  Created by Stephen Fox on 04/08/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SASGalleryContainer : NSObject


- (NSArray *) currentData;
// For KVC compliance, publicly declared for readability
- (void)insertObject:(id)object inDataAtIndex:(NSUInteger)index;
- (void)removeObjectFromDataAtIndex:(NSUInteger)index;
- (id)objectInDataAtIndex:(NSUInteger)index;
- (NSArray *)dataAtIndexes:(NSIndexSet *)indexes;
- (NSUInteger)countOfData;

@end
