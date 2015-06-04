//
//  UIView+FrameValues.m
//  Photoapp4it
//
//  Created by Peter FitzGerald on 28/07/2013.
//

#import "UIView+FrameValues.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"

@implementation UIView (FrameValues)

extern BOOL NSLogOn;

-(void)frameValues:(NSString *)name {
	plog(@"%@: %@", name.uppercaseString, self.description);
}

@end
