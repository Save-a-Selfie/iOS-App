//
//  SASFilterViewCell.h
//  Save a Selfie
//
//  Created by Stephen Fox on 21/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASDevice.h"

@interface SASFilterViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (assign, nonatomic) SASDeviceType associatedDeviceType;


// @param BOOL:
//  YES: Sets the tick to green.
//  NO:  Sets the tick to grey.
- (void)setCellWithGreenTick: (BOOL) status;

@end
