//
//  SignUpWorker.h
//  Save a Selfie
//
//  Created by Stephen Fox on 07/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SignUpWorker <NSObject>

typedef void (^SignUpWorkerCompletionBlock)(NSError * error);


// Usually there will be some parameters to be used
// with sign up e.g. email, name etc.
@property(strong, nonatomic) NSDictionary *param;


- (void) signupWithCompletionBlock:(SignUpWorkerCompletionBlock) completion;



@end
