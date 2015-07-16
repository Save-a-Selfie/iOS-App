//
//  EULAView.m
//  Save a Selfie
//

#import "EULAViewController.h"
#import "StorageSystem.h"
#import "UIView+NibInitializer.h"
#import "ExtendNSLogFunctionality.h"


#define DATAFILE @"EULA.html"
#define ROOT @"http://www.saveaselfie.org/SASDocs/"


@implementation EULAViewController

@synthesize delegate;
@synthesize webView = _webView;
@synthesize segmentedControl;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self EULALoaded];
}

- (void)EULALoaded {
    
    [self getLocalPage:DATAFILE andNavCon:nil];
}

- (void)getLocalPage:(NSString *)file andNavCon:(UINavigationController *)navCon {
    NSString *responseString = [self getPage:ROOT file:file navCon:nil encoding:0]; // pulls file from storage - either own cache or bundle
    
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
    
    [storage loadURL:file withRoot:ROOT];
}

- (NSString *)getPage: (NSString *)root file:(NSString *)file navCon:(UINavigationController *)navCon encoding:(int)encoding
{
    // also need to pull file from bundle if it is there, while new version is (possibly) downloading
    StorageSystem *tempStorage = [[StorageSystem alloc] init];
    tempStorage.textEncoding = encoding;
    return [tempStorage loadFileFromDefaultManagerOrBundle:file];
}


- (void) updateEULATable {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    NSString *URL = @"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/updateEULA.php";
    [request setURL:[NSURL URLWithString:URL]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *parameters = [ NSString stringWithFormat:@"deviceID=%@&EULAType=EULA", [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; // don't need result of this
    if(connection){/*Get rid of the unused variable warning*/}
}


- (IBAction)agreeDeclineAction:(UISegmentedControl *) sender {
    
    // 0: Accepted
    // 1: Declined
    printf("PRESSED INDEX: %ld\n\n\n\'n", sender.selectedSegmentIndex);
    
    EULAResponse response;
    
    if (sender.selectedSegmentIndex == 0) {
        
        response = EULAResponseAccepted;
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"EULAAccepted"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        
        response = EULAResponseDeclined;
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"EULAAccepted"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // Forward to delegate
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(eulaView:userHasRespondedWithResponse:)]) {
        [self.delegate eulaView:self userHasRespondedWithResponse:response];
    }
}

@end
