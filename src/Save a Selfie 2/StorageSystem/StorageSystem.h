//
//  StorageSystem.h
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface StorageSystem: NSObject <MBProgressHUDDelegate> {
    NSURLRequest *request;
    NSString *notificationString;
    NSString *responseString;
	MBProgressHUD *HUD;
	UIWebView *webView;
    NSString *saveDataToDefaultManager; // name of file to save, if needed
	UINavigationController *showTitleNavCon;
	bool downloadDone;
}
@property (retain) UINavigationController *showTitleNavCon;
@property (retain) NSString *saveDataToDefaultManager;
@property (strong) NSString *notificationString;
@property (strong) UIWebView *webView;
@property (strong) NSString *responseString;
@property (strong) NSString *URLParameters;
@property (strong) NSURLRequest *request;
@property (strong) MBProgressHUD *HUD;
@property (strong) UIView *HUDView; // will be webView or imageView
@property bool downloadDone;
@property bool indicateOldNew; // if YES, indicate whether downloaded file is old or new by putting "old" or "new" on notification after notificationString and space
@property bool dataFile; // true if downloading data, rather than HTML file
@property int textEncoding; // normally UTF8, but could be different
- (void)loadURL:(NSString *)urlString withRoot:(NSString *)root;
- (NSString *)getFullFilePath: (NSString *)fileName;
- (void)saveString:(NSString *)responseString atPath:(NSString *)infoFilename;
- (NSString *)loadFileFromDefaultManagerOrBundle:(NSString *)infoFilename;
@end
