//
//  ExtendNSLogFunctionality.h
//  Photoapp4it
//
//  Created by Peter FitzGerald on 17/11/2013.
//
// modified a little from: http://mobile.tutsplus.com/tutorials/iphone/customize-nslog-for-easier-debugging/
//
#import <Foundation/Foundation.h>

@interface ExtendNSLogFunctionality : NSObject

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

@end
