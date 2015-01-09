//
//  MKSASAnnotationView.h
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 28/12/2014.
//  Copyright (c) 2014 Peter FitzGerald. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Device.h"

@interface MKSASAnnotationView : MKAnnotationView {}
@property (nonatomic, strong) Device *device;
@end
