//
//  SASNetworkUtilities.h
//  Save a Selfie
//
//  Created by Stephen Fox on 05/07/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SASNetworkUtilities : NSObject


+ (NSString*) encodeToPercentEscapeString:(NSString *)string;



+ (NSString*) decodeFromPercentEscapeString:(NSString *)string;

@end
