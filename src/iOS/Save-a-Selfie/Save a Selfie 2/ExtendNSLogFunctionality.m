//
//  ExtendNSLogFunctionality.m
//  Photoapp4it
//
//  Created by Peter FitzGerald on 17/11/2013.
//  Copyright (c) 2013 Peter FitzGerald. All rights reserved.
//

#import "ExtendNSLogFunctionality.h"

@implementation ExtendNSLogFunctionality

extern BOOL NSLogOn;

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...)
{
	if (!NSLogOn) return;
    // Type to hold information about variable arguments.
    va_list ap;
    // Initialize a variable argument list.
    va_start (ap, format);
    // NSLog only adds a newline to the end of the NSLog format if
    // one is not already there.
    // Here we are utilizing this feature of NSLog()
    if (![format hasSuffix: @"\n"])
    {
        format = [format stringByAppendingString: @"\n"];
    }
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    // End using variable argument list.
    va_end (ap);
//    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    fprintf(stderr, "%s %d:\t%s",
            functionName,
            lineNumber, [body UTF8String]);
}
@end
