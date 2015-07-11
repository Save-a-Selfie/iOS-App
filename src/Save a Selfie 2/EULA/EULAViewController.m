//
//  EULA.m
//  Save a Selfie
//

#import "EULAViewController.h"
#import "StorageSystem.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"
#define DATAFILE @"EULA.html"
#define ROOT @"http://www.saveaselfie.org/SASDocs/"

@interface EULAViewController ()

@end

@implementation EULAViewController

@synthesize delegate;

- (void)EULALoaded {
    plog(@"EULALoaded entered");
    [self getLocalPage:DATAFILE andNavCon:nil];

}

-(void)getLocalPage:(NSString *)file andNavCon:(UINavigationController *)navCon {
    NSString *responseString = [self getPage:ROOT file:file navCon:nil encoding:0]; // pulls file from storage - either own cache or bundle
    plog(@"responseString: %@", responseString);
    [_webView loadHTMLString:responseString baseURL:nil];
    // now try and download and save file
    StorageSystem *storage = [[StorageSystem alloc] init];
    storage.saveDataToDefaultManager = file;
    storage.webView = _webView;
    storage.HUDView = nil;
    storage.showTitleNavCon = nil;
    storage.notificationString = file;
    storage.dataFile = NO;
    storage.textEncoding = 0; // * ! *
    storage.indicateOldNew = NO;
    plog(@"ROOT: %@, file: %@", ROOT, file);
    [storage loadURL:file withRoot:ROOT];
}


-(NSString *)getPage: (NSString *)root file:(NSString *)file navCon:(UINavigationController *)navCon encoding:(int)encoding
{
    // also need to pull file from bundle if it is there, while new version is (possibly) downloading
    StorageSystem *tempStorage = [[StorageSystem alloc] init];
    tempStorage.textEncoding = encoding;
    return [tempStorage loadFileFromDefaultManagerOrBundle:file];
}


- (IBAction)agreeDeclineAction:(UISegmentedControl *)segmentedControl {
    
    EULAUserRespose response = -1;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"EULAAccepted"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        response = EULAAccepted;
        printf("Accepted");
    }
    else {
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"EULAAccepted"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        printf("Declined");
        response = EULADeclined;

    }
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(eula:didReceiveResponseFromUser:)]) {
        [self.delegate eula:self didReceiveResponseFromUser:response];
    }
}

@end
