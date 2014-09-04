//
//  FindAEDViewController.h
//  Save-a-Selfie
//
//  Created by Nadja Deininger on 23/05/14.
//  Copyright (c) 2014 Code for All Ireland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FindAEDViewController : UIViewController
<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (readonly) NSMutableData *jsonData;
@property (readonly) NSArray *jsonArray;

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;
- (void)populateMapViewFromJSON;
@end
