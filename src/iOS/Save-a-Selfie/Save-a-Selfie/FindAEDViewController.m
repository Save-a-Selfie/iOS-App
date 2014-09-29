//
//  FindAEDViewController.m
//  Save-a-Selfie
//
//  Created by Nadja Deininger on 23/05/14.
//  Copyright (c) 2014 Code for All Ireland. All rights reserved.
//

#import "FindAEDViewController.h"
#import "AEDLocation.h"
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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
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
        _jsonArray = [NSJSONSerialization JSONObjectWithData:_jsonData options:kNilOptions error:&error];
        
        for(NSDictionary *item in _jsonArray) {
            NSLog(@"item: %@", item);
            NSNumber * latitude = [item valueForKey:@"latitude"];
            NSNumber * longitude = [item valueForKey:@"longitude"];
            CLLocationCoordinate2D coord;
            coord.latitude = (CLLocationDegrees) [latitude doubleValue];
            coord.longitude = (CLLocationDegrees) [longitude doubleValue];
            AEDLocation *annotation = [[AEDLocation alloc] init];
            [annotation setCoordinate:coord];
            [annotation setTitle:[item valueForKey:@"uploadedby"]];
            [annotation setSubtitle:[item valueForKey:@"comment"]];
            NSInteger databaseID = [[item valueForKey:@"id"] integerValue];
            [annotation setDatabaseID:databaseID];
            
            MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: [item valueForKey:@"id"]];
            [view setTag:[[item valueForKey:@"id"] integerValue]];
            [_mapView addAnnotation:annotation];
        }
    }
    else {
        NSLog(@"_jsonData is nil");
    }
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [view setCanShowCallout:YES];
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [view setCanShowCallout:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    CGSize  calloutSize = CGSizeMake(100.0, 120.0);
    AEDLocation *location = annotation;
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:location reuseIdentifier:@"loc"];

    UIImage *image;
    
    for(NSDictionary *item in _jsonArray) {
        NSLog(@"%ld", (long)[[item valueForKey:@"id"] integerValue]);
        if([[item valueForKey:@"id"] integerValue] == location.databaseID) {
            NSString *imageString = [item objectForKey:@"thumbnail"];
            if(imageString) {
                NSData *finalImageData = [[NSData alloc] initWithBase64EncodedString:imageString options:0];
                image = [[UIImage alloc] initWithData:finalImageData];
            }
        }
    }
    if(!image) {
        // this is not likely to happen: there is an entry in the database but no thumbnail was sent in the JSON.
        // Anyway, if it does happen, just don't display anything.
        image = [[UIImage alloc] init];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [imageView setImage:image];
    
    [annotationView addSubview:imageView];

    return annotationView;
 
}


// apparently initWithBase64EncodedString will not parse a base 64 encoded string correctly if its length is
// not a multiple of 4, and it needs to be padded with = characters?
- (NSString *) padStringToMultipleOfFour:(NSString *) str
{
    unsigned int modulus = [str length] % 4;
    NSString * padding = @"";
    for (int i = 4; i > modulus; i--)
    {
        padding = [padding stringByAppendingString:@"="];
    }
    
    return [str stringByAppendingString:padding];
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
