//
//  SignUpWorker.h
//  Save a Selfie
//
//  Created by Stephen Fox on 07/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpWorker <NSObject>


- (void) setParams:(NSSet*) set;

- (void) signup;

@end
