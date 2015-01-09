//
//  MKSASAnnotationView.m
//  Save a Selfie 2
//
//  Runs through each of the annotations (pins) at least once to check if any have been tapped
//

#import "MKSASAnnotationView.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"
#import "PopupImage.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"

@implementation MKSASAnnotationView

extern PopupImage *popupImage;
bool tapped = false;
bool isInside;
int checkCount = 0;

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    // https://gist.github.com/ShadoFlameX/7495098
    if (popupImage && CGRectContainsPoint(popupImage.frame, point)) {
        plog(@"returning popupImage");
        return popupImage;
    } else {
//        plog(@"returning nil");
        return nil;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    return NO;
//    CGRect rect = self.bounds; // 'self' is each pin / marker in turn
////    if (!tapped) {
////        tapped = true;
////        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC);
////        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            isInside = CGRectContainsPoint(rect, point);
//            tapped = false;
//            plog(@"isInside: %d", isInside);
//            if(!isInside)
//            {
//                for (UIView *view in self.subviews)
//                {
//                    isInside = CGRectContainsPoint(view.frame, point);
//                    if (CGRectContainsPoint(popupImage.textView.frame, point)) plog(@"it's in the text");
//                    if (CGRectContainsPoint(popupImage.xButton.frame, point)) plog(@"it's in the X");
//                    if(isInside)
//                        break;
//                }
//            }
////        });
////    }
//    return isInside;
}

@end
