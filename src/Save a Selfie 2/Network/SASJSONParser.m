//
//  SASJSONParser.m
//  Save a Selfie
//
//  Created by Stephen Fox on 10/03/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import "SASJSONParser.h"

@implementation SASJSONParser

+ (NSDictionary*) parseSignUpResponse:(NSDictionary*) json {
  return [json objectForKey:@"responseMessage"];
}


+ (NSObject*) parseGetAllSelfieResponseMessage:(NSDictionary*) json {
  return [json objectForKey:@"responseMessage"];
}

+ (NSArray *)parseGetAllSelfieData:(NSDictionary *)json {
  return [json objectForKey:@"data"];
}

+ (NSInteger)parseInsertStatus:(NSDictionary *)json {
  NSNumber *insertStatus = [[json objectForKey:@"responseMessage"] objectForKey:@"insert_status"];
  return insertStatus.integerValue;
}
@end
