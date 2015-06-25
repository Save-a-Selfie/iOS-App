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

@synthesize deviceName;
@synthesize selectionStatusImageView;
@synthesize selectionStatus;



- (void)awakeFromNib {
}



- (void)setSelectionStatus:(BOOL)status {
    
    if (status) {
        self.selectionStatusImageView.image = [UIImage imageNamed:@"CellSelected"];
    }
    else {
        self.selectionStatusImageView.image = [UIImage imageNamed:@"CellUnselected"];
    }
}





@end
