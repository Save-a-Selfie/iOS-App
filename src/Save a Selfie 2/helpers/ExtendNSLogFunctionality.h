//
//  ExtendNSLogFunctionality.h
//
// modified a little from: http://mobile.tutsplus.com/tutorials/iphone/customize-nslog-for-easier-debugging/
//
#import <Foundation/Foundation.h>

@interface ExtendNSLogFunctionality : NSObject

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

@end
