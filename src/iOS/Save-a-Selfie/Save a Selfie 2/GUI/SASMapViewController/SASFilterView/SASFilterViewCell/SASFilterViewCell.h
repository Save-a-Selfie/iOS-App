//
//  SASFilterViewCell.h
//  Save a Selfie
//
//  Created by Stephen Fox on 25/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"
@interface SASFilterViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (assign, nonatomic) SASDevice* associatedDevice;

- (void) updateSelectionStatus;
@end
