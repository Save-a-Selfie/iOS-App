//
//  EULAView.m
//  Save a Selfie
//

#import "EULAViewController.h"
#import "StorageSystem.h"
#import "UIView+NibInitializer.h"
#import "ExtendNSLogFunctionality.h"

@interface EULAViewController()

@property (weak, nonatomic) NSString* dataFile;
@property (weak, nonatomic) NSString* root;

@end

@implementation EULAViewController
@synthesize delegate;

@synthesize webView;
@synthesize segmentedControl;

@synthesize dataFile = _dataFile;
@synthesize root = _root;

#pragma mark Object Life Cycle
- (id) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        _dataFile = [NSString stringWithFormat:@"EULA.html"];
        _root = [NSString stringWithFormat:@"http://www.saveaselfie.org/SASDocs/"];
    }
    return self;
}




- (void) loadEULAData {
    [self getLocalPage:self.dataFile];
}


// Gets the cached EULA document.
- (void)getLocalPage:(NSString *)file {
    NSString *responseString = [self getPage:self.root file:file withEncoding:0];
    
    [self.webView loadHTMLString:responseString baseURL:nil];
    
    StorageSystem *storage = [[StorageSystem alloc] init];
    storage.saveDataToDefaultManager = file;
    storage.webView = self.webView;
    storage.HUDView = nil;
    storage.showTitleNavCon = nil;
    storage.notificationString = file;
    storage.dataFile = NO;
    storage.textEncoding = 0;
    storage.indicateOldNew = NO;
    [storage loadURL:file withRoot:self.root];
    
    
}


- (NSString *) getPage: (NSString *) root file:(NSString *) file withEncoding:(int) encoding {
    
    // Also need to pull the file from bundle if it is there, while new version is (possibly) downloading.
    StorageSystem *tempStorage = [[StorageSystem alloc] init];
    tempStorage.textEncoding = encoding;
    return [tempStorage loadFileFromDefaultManagerOrBundle:file];
    
}


- (void)updateEULATable {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    NSString *URL = @"http://www.saveaselfie.org/wp/wp-content/themes/magazine-child/updateEULA.php";
    [request setURL:[NSURL URLWithString:URL]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *parameters = [NSString stringWithFormat:@"deviceID=%@&EULAType=EULA", [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(connection) {/* To get rid of the annoing 'unused variable' warning*/}
}


- (IBAction)agreeDeclineAction:(UISegmentedControl *) sender {
    
    EULAResponse response;
    
    if (sender.selectedSegmentIndex == 1) {
        
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
