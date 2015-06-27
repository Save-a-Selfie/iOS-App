//
//  SASFilterViewCell.m
//  Save a Selfie
//
//  Created by Stephen Fox on 25/06/2015.
//  Copyright (c) 2015 Stephen Fox. All rights reserved.
//

#import "SASFilterViewCell.h"

@interface SASFilterViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *selectionStatusImageView;

@end

@implementation SASFilterViewCell

@synthesize deviceNameLabel;
@synthesize selectionStatusImageView;
@synthesize selectionStatus;
@synthesize associatedDevice;


- (void)awakeFromNib {
}




- (void) updateSelectionStatus:(BOOL) status {
   
    if(status == YES) {
        printf("Should be on.\n");
        self.selectionStatusImageView.image = [UIImage imageNamed:@"CellSelected"];
    } else if(status == NO) {
        printf("Should be off.\n");
        self.selectionStatusImageView.image = [UIImage imageNamed:@"CellUnselected"];
    }
}






@end
