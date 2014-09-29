//
//  FindAEDViewController.h
//  Save-a-Selfie
//
//  Created by Nadja Deininger on 23/05/14.
//  Copyright (c) 2014 Code for All Ireland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface FindAEDViewController : UIViewController
<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (readonly) NSMutableData *jsonData;
@property (readonly) NSArray *jsonArray;
@property CLLocationManager *locationManager;

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;
- (void)populateMapViewFromJSON;
@end
