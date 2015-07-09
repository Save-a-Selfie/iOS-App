//
//  StorageSystem.m
//  IMMA
//
//  Created by Dnote DotInfo on 06/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StorageSystem.h"
#import "NSString+PDRegex.h"
#import "ExtendNSLogFunctionality.h"
#import "AppDelegate.h"

@implementation StorageSystem
@synthesize request;
@synthesize notificationString;
@synthesize responseString;
@synthesize webView;
@synthesize HUD, HUDView;
@synthesize saveDataToDefaultManager;
@synthesize showTitleNavCon;
@synthesize downloadDone; // set to YES when download finished
@synthesize dataFile;
@synthesize textEncoding;
@synthesize indicateOldNew;
NSURLConnection *connection;
NSString *file; // file to be downloaded - set in loadURL
NSString *root;
BOOL remoteNewer = NO;
NSMutableData *responseData;
int expectedFileSize = -1;

extern BOOL NSLogOn;

- (void)loadURL:(NSString *)urlString withRoot:(NSString *)theRoot
{
	responseData = [[NSMutableData alloc] init];
    [responseData setLength:0];
	downloadDone = NO;
	file = urlString;
	root = theRoot;
    NSString *params = [self.URLParameters rangeOfString:@"(null)"].location != NSNotFound ? @"" : self.URLParameters;
	NSString *urlString2 = [NSString stringWithFormat:@"%@%@%@", root, urlString, params];
	NSString *urlString3 = [urlString2 stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSURL *url = [NSURL URLWithString:urlString3];
    request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]; // cache policy very important - otherwise reloads local
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if ((webView || dataFile) && HUDView) { // creating spinner if a web view is to be loaded
		plog(@"HUDView is %@", HUDView);
		HUD = [MBProgressHUD showHUDAddedTo:HUDView animated:YES];
		HUD.labelText = @"Loading…";
	}
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	plog(@"response received %@", response);
	/*  convert response into an NSHTTPURLResponse,
	 call the allHeaderFields property, then get the
	 Last-Modified key.
	 Found here: http://stackoverflow.com/questions/6895451/how-to-get-remote-file-modification-date
     */
	/* can't rely on IIS to give the correct mod date - need to look at creation date as well - which tens also to be wrong... */
	NSDictionary *dateDict = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"01", @"Jan", @"02", @"Feb", @"03", @"Mar", @"04", @"Apr",
							  @"05", @"May", @"06", @"Jun", @"07", @"Jul", @"08", @"Aug",
							  @"09", @"Sep", @"10", @"Oct", @"11", @"Nov", @"12", @"Dec",
							  nil];
	plog(@"remote header: %@", [(NSHTTPURLResponse *)response allHeaderFields]);
	expectedFileSize = [[[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Content-Length"] intValue];
    NSString * last_modified = [NSString stringWithFormat:@"%@",
								[[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Last-Modified"]];
//    NSString * createDate = [NSString stringWithFormat:@"%@", [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"date"]];
	
	plog(@"in StorageSystem, file is %@", file);
	plog(@"Remote file last modified: %@", last_modified );
//	plog(@"Remote file created: %@", createDate);
	
	NSArray *t = [last_modified componentsSeparatedByString:@" "];
	if (t.count < 5) { plog(@"remote file does not seem to exist, or has no last-modified info!"); remoteNewer = YES; return; }
	NSString *remoteLastModified = [NSString stringWithFormat:@"%@-%@-%@ %@ +0000",
									[t objectAtIndex:3],
									[dateDict objectForKey:[t objectAtIndex:2]],
									[t objectAtIndex:1],
									[t objectAtIndex:4]];
	NSString *path = [self getFullFilePath:file];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]) {
		NSError * err = nil;
		NSDictionary * attributes = [fileManager attributesOfItemAtPath:path error:&err];
		NSString * localLastModified = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"NSFileModificationDate"]];
		plog(@"Local-file last modification: %@", localLastModified);
		NSComparisonResult result = [remoteLastModified compare:localLastModified];
		if (result == NSOrderedAscending)
		{
			remoteNewer = NO;
			plog(@"Remote file has not been modified after local date.");
			[connection cancel];
			if ((webView || dataFile) && HUDView) [MBProgressHUD hideHUDForView:HUDView animated:YES];
			// get file from directory
			NSString *r = [[NSString alloc] initWithContentsOfFile:path encoding:(textEncoding == 0) ? NSUTF8StringEncoding: textEncoding error:nil];
			responseData = [NSMutableData dataWithData:[r dataUsingEncoding:(textEncoding == 0) ? NSUTF8StringEncoding: textEncoding]];
			saveDataToDefaultManager = nil;
			plog(@"not downloading");
			[[NSNotificationCenter defaultCenter]
			 postNotificationName:[NSString stringWithFormat:@"%@%@", notificationString, @" old"]
			 object:nil];
			[self connectionDidFinishLoading:connection];
			return;
			//plog(@"no need to download (%d bytes read from file)", [r length]);
		} else plog(@"downloading %@ (remote: %@, local: %@)", file, remoteLastModified, localLastModified);
	} else plog(@"file does not exist at %@!", path);
	remoteNewer = YES;
}

-(void) connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data{
		plog(@"data received - length %d (%d)", data.length, responseData.length);
		[responseData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
	if ((webView || dataFile) && HUDView) [MBProgressHUD hideHUDForView:HUDView animated:YES];
	if (!dataFile) { // it's a HTML file
		NSString *data = [[NSString alloc] initWithData:responseData encoding:(textEncoding == 0) ? NSUTF8StringEncoding: textEncoding];
		if (saveDataToDefaultManager) {
			[self saveString:data atPath:saveDataToDefaultManager];
		}
		if (webView && remoteNewer) {
			plog(@"loading data to webView %@", webView);
			[webView loadHTMLString:data baseURL:nil]; }
		if (showTitleNavCon) {
			// NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"]; // doesn't work for some reason - maybe webView still loading?
			NSString *title2 = [data stringByReplacingRegexPattern:@".*?<title>(.*?)</title>.*$" withString:@"$1" caseInsensitive:YES treatAsOneLine:YES];
			showTitleNavCon.navigationBar.topItem.title = title2;
		}
	} else { // it's a data file
		plog(@"it's a data file");
		if (saveDataToDefaultManager) {
			plog(@"saving data file");
			[self saveData:saveDataToDefaultManager];
		}
	}
}

-(void)notify {
	downloadDone = YES;
	plog(@"download finished");
	if (notificationString) // broadcast that load has finished
	{	NSString *oldNew = indicateOldNew ? (remoteNewer ? @" new" : @" old") : @"";
		plog(@"sending notification %@", [NSString stringWithFormat:@"%@%@", notificationString, oldNew]);
		[[NSNotificationCenter defaultCenter]
         postNotificationName:[NSString stringWithFormat:@"%@%@", notificationString, oldNew]
         object:nil];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// this does not get called
}

- (NSString *)getFullFilePath: (NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *path = [cacheDirectory stringByAppendingPathComponent:fileName];
    return path;
}

- (void)saveString:(NSString *)theResponseString atPath:(NSString *)infoFilename
{
    NSString *path = [self getFullFilePath:infoFilename];
    // save string to file
	plog(@"writing %d bytes to %@", [theResponseString length], infoFilename);
    [theResponseString writeToFile:path atomically:NO encoding:(textEncoding == 0) ? NSUTF8StringEncoding: textEncoding error:nil];
	[self notify];
}

- (void)saveData:(NSString *)infoFilename
{
    NSString *path = [self getFullFilePath:infoFilename];
    // save string to file
	plog(@"writing %d bytes to %@ %@ (%d expected)", [responseData length], path, infoFilename, expectedFileSize);
	if (responseData.length >= expectedFileSize) {
		NSError* error;
		[responseData writeToFile:path options:NSDataWritingAtomic error:&error];
		if (error) plog(@"error: %@", error);
		[self notify];
	} else {
		plog(@"discrepancy - redoing");
		[self loadURL:file withRoot:root];
	}
}

- (NSString *)loadFileFromDefaultManagerOrBundle:(NSString *)infoFilename
{
    // This method reads in an essential file. If it has already been downloaded, then it is read from the defaultManager system, where it is stored; otherwise it is taken from the bundle that comes with the app
	NSString *infoFilename2 = [infoFilename stringByReplacingOccurrencesOfString:@"pages/" withString:@""];
    NSString *path = [self getFullFilePath:infoFilename2];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]) {
		plog(@"file %@ exists", path);
        NSString *text = [[NSString alloc] initWithContentsOfFile:path encoding:(textEncoding == 0) ? NSUTF8StringEncoding: textEncoding error:nil];
		plog(@"length of loaded text: %d, encoding is %d", [text length], textEncoding);
        return text;
    }
    else { // file doesn't exist - need to load file from infoFilename2 in Bundle...
		NSString *infoFilename3 = [infoFilename2 stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        NSArray *parts = [infoFilename3 componentsSeparatedByString:@"."];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[parts objectAtIndex:0] ofType:[parts objectAtIndex:1]];
        if (filePath) {
            NSString *text = [NSString stringWithContentsOfFile:filePath encoding:(textEncoding == 0) ? NSUTF8StringEncoding: textEncoding error:nil];
			// write it to the file manager, for next time
			plog(@"%@ found in bundle, length of loaded text: %d", filePath, [text length]);
            return text;
        } else { plog(@"***** Problem - %@ not found defaultManager or in Bundle", infoFilename3); return @""; }
    }
}

@end
