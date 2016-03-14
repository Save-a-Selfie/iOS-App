//
//  SignUpWorker.h
//  Save a Selfie
//
//  Created by Stephen Fox on 07/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SignUpWorkerResponse) {
  SignUpWorkerResponseUserExists = 101,
  SignUpWorkerResponseSuccess = 103,
  SignUpWorkerResponseFailed = 102,
};

@protocol SignUpWorker <NSObject>

typedef void (^SignUpWorkerCompletionBlock)(NSString *email, NSString *token, SignUpWorkerResponse response);


/** The parameters used with Facebook.
 *  By setting these params, the information
 *  for signup will be taken from Facebook.
 */
@property(strong, nonatomic) NSDictionary *faceBookParam;

/** The parameters used with Twitter SDK.
 *  By setting these params, the information
 *  for signup will be taken from Twitter.
*/
@property(strong, nonatomic) NSDictionary *twitterParam;


- (void) signupWithCompletionBlock:(SignUpWorkerCompletionBlock) completion;


@end
