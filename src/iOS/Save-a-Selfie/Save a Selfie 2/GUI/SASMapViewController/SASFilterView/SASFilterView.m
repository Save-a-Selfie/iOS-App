//
//  SASFilterView.m
//  
//
//  Created by Stephen Fox on 12/06/2015.
//
//

#import "SASFilterView.h"
#import "SASUtilities.h"
#import "ILTranslucentView.h"
#import "SASDevice.h"
#import "SASFilterViewCell.h"
#import "UIFont+SASFont.h"


@interface SASFilterView() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
@property (assign, nonatomic) SASDeviceType selectedDevice;

@end

@implementation SASFilterView

@synthesize tableView;
@synthesize filterLabel;
@synthesize delegate;
@synthesize selectedDevice;


#pragma Object Life Cycle.
- (instancetype)init {
    
    if(self = [super init]) {
        
       self = [[[NSBundle mainBundle]
                loadNibNamed:@"SASFilterView"
                owner:self
                options:nil]
               firstObject];
        
        [UIFont increaseCharacterSpacingForLabel:self.filterLabel byAmount:2.3];
        self.layer.cornerRadius = 8.0;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.layer.cornerRadius = 8.0;
        
        // Register SASFilterViewCell.
        [self.tableView registerNib:[UINib nibWithNibName:@"SASFilterViewCell" bundle:nil]
             forCellReuseIdentifier:@"sasFilterViewCell"];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}



#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SASFilterViewCell *selectedCell = (SASFilterViewCell*)[aTableView cellForRowAtIndexPath:indexPath];
    [selectedCell updateSelectionStatus];
    
    self.selectedDevice = selectedCell.associatedDevice.type;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SASFilterViewCell *sasFilterViewCell = (SASFilterViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"sasFilterViewCell"];
    
    sasFilterViewCell.associatedDevice.type = 2;
    
    sasFilterViewCell.deviceNameLabel.text = [SASDevice getDeviceNameForDeviceType:indexPath.row];
    
    sasFilterViewCell.imageView.image = [SASDevice getDeviceImageForDeviceType:indexPath.row];
    
    return sasFilterViewCell;
}



// TODO: Add logic for what cells can be selected together etc.
// Forwards selected cells associatedDevice to delegate.
- (IBAction)doneButtonPressed:(id)sender {
    if(delegate != nil && [delegate respondsToSelector:@selector(sasFilterView:doneButtonWasPressedWithSelectedDeviceType:)]) {
        [self.delegate sasFilterView:self doneButtonWasPressedWithSelectedDeviceType:self.selectedDevice];
    }
}



#pragma Animations
// Animates into the views center.
- (void) animateIntoView:(UIView*) view {
    
    
    [UIView animateWithDuration:0.3
                          delay:0.1
         usingSpringWithDamping:0.6
          initialSpringVelocity:.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){ self.center = view.center;}
                     completion:^(BOOL visible){[self updateDelegateOnViewVisibility:YES];}
     ];
}


- (void) animateOutOfView:(UIView*) view {
    
    [UIView animateWithDuration:0.4
                          delay:0.1
         usingSpringWithDamping:0.6
          initialSpringVelocity:.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){ self.frame = CGRectOffset(self.frame,
                                                               self.frame.origin.x,
                                                               -700);
                     }
                     completion:^(BOOL visible){[self updateDelegateOnViewVisibility:NO];}
     ];
}


- (void) updateDelegateOnViewVisibility:(BOOL) visibility {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sasFilterView:isVisibleInViewHierarhy:)]) {
        [self.delegate sasFilterView:self isVisibleInViewHierarhy:visibility];
    }
}


@end
