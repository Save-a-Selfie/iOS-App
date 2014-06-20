//
//  FindAEDViewController.m
//  Save-a-Selfie
//
//  Created by Nadja Deininger on 23/05/14.
//  Copyright (c) 2014 Code for All Ireland. All rights reserved.
//

#import "FindAEDViewController.h"
#import <Foundation/NSJSONSerialization.h>

@interface FindAEDViewController ()

@end

@implementation FindAEDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
    
    [self populateMapViewFromJSON];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}


- (void) populateMapViewFromJSON
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gunfire.becquerel.org/entries/"]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection) {
        NSLog(@"Error establishing the HTTP connection.");
    }
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_jsonData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(!_jsonData) {
        _jsonData = [NSMutableData data];
    }
    
    [_jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    if(_jsonData) {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_jsonData options:kNilOptions error:&error];
        
        for(NSDictionary *item in jsonArray) {
            NSLog(@"latitude: %@", [item valueForKey:@"latitude"]);
            NSNumber * latitude = [item valueForKey:@"latitude"];
            NSNumber * longitude = [item valueForKey:@"longitude"];
            CLLocationCoordinate2D coord;
            coord.latitude = (CLLocationDegrees) [latitude doubleValue];
            coord.longitude = (CLLocationDegrees) [longitude doubleValue];
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:coord];
            [annotation setTitle:[item valueForKey:@"uploadedby"]];
            [annotation setSubtitle:[item valueForKey:@"comment"]];
            MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: [item valueForKey:@"id"]];
            
            [_mapView addAnnotation:annotation];
        }
    }
    else {
        NSLog(@"_jsonData is nil");
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
