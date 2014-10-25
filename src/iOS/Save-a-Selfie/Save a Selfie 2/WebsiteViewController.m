//
//  WebsiteViewController.m
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 15/10/2014.
//  Copyright (c) 2014 Peter FitzGerald. All rights reserved.
//

#import "WebsiteViewController.h"
#import "AppDelegate.h"
#import "ExtendNSLogFunctionality.h"
#import "UIView+WidthXY.h"

@interface WebsiteViewController ()

@end

@implementation WebsiteViewController

NSMutableData *responseData;
NSURLConnection *connection;
BOOL iPhone5;

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    plog(@"finished loading");
    [_webView loadHTMLString:data baseURL:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    iPhone5 = YES;
    responseData = [NSMutableData data];
    [_webView changeViewWidth:[[UIScreen mainScreen] bounds].size.width atX:0 centreIt:YES duration:0];
    NSURL *url = [NSURL URLWithString:@"http://iculture.info/saveaselfie/ix.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
