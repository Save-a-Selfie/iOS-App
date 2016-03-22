//
//  ImageReporter.h
//  Save a Selfie
//
//  Created by Stephen Fox on 22/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageReporter <NSObject>


- (void) reportImage:(NSString*) filepath
          completion:(void(^)(BOOL success)) completion;


@end
