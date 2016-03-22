//
//  DefaultImageReporter.m
//  Save a Selfie
//
//  Created by Stephen Fox on 22/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "DefaultImageReporter.h"
#import <Unirest/UNIRest.h>
#import "SASUser.h"
#import "SASJSONParser.h"

@implementation DefaultImageReporter


NSString *REPORT_IMAGE_URL = @"https://guarded-mountain-99906.herokuapp.com/reportFileById/";

- (void)reportImage:(NSString *)filepath completion:(void (^)(BOOL))completion {
  [self report:filepath completion:completion];
}


- (void) report:(NSString *)filepath completion:(void (^)(BOOL))completion {
  [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
    NSDictionary *userInfo = [SASUser currentLoggedUser];
    NSString *token = [userInfo objectForKey:USER_DICT_TOKEN];
    
    NSString *tokenFormat = [NSString stringWithFormat:@"Bearer %@", token];
    
    [simpleRequest setUrl:[NSString stringWithFormat:@"%@%@", REPORT_IMAGE_URL, filepath]];
    [simpleRequest setHeaders:@{@"Accept": @"application/json",
                                @"Content-Type": @"application/json",
                                @"Authorization": tokenFormat}];
    NSLog(@"%@", tokenFormat);
  }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
    NSInteger response = [SASJSONParser parseInsertStatus:jsonResponse.body.object];
    
    if (response == 302) {
      completion(YES);
    } else {
      completion(NO);
    }
  }];
}

@end
