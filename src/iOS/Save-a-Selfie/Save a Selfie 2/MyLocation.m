//
//  MyLocation.m
//

#import "MyLocation.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"

@implementation MyLocation

extern NSArray *deviceNames;
extern NSArray *devicePins;

- (id)initWithDevice:(Device *)d index:(int)dNo {
    if ((self = [super init])) {
        _name = [deviceNames[d.typeOfObjectInt] copy];
        _coordinate = d.deviceLocation;
        _image = (UIImage *)devicePins[d.typeOfObjectInt];
        _device = d;
        _index = dNo;
    }
//    plog(@"dNo is %d", dNo);
//    plog(@"self.image (%d): %@, %@, %d, %@", dNo, self.image, _image, d.typeOfObjectInt, d.typeOfObject);
    return self;
}

- (NSString *)title {
    return _name;
}

- (Device *)device { return _device; }
- (int)index { return _index; }
- (UIImage *)image { return _image; }
- (NSString *)subtitle { return _address; }

- (void)dealloc
{
    _name = nil;
    _address = nil;
    _image = nil;
}

@end
