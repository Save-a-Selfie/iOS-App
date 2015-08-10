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
@property (assign, nonatomic) BOOL selectionStatus;
@end

@implementation SASFilterViewCell




- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setCellWithGreenTick:NO];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}




- (void) setCellWithGreenTick: (BOOL) status {
    if (status == YES) {
        self.selectionStatusImageView.image = [UIImage imageNamed:@"SelectedCell"];
        self.selectionStatus = YES;
    }
    else {
        self.selectionStatusImageView.image = [UIImage imageNamed:@"UnselectedCell"];
        self.selectionStatus = NO;
    }
}


@end
