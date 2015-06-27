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


@interface SASFilterView() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* selectedCellsAssociatedDevice;

@end

@implementation SASFilterView

@synthesize tableView;
@synthesize delegate;
@synthesize selectedCellsAssociatedDevice;

- (instancetype)init {
    
    if(self = [super init]) {
        
       self = [[[NSBundle mainBundle]
                loadNibNamed:@"SASFilterView"
                owner:self
                options:nil]
               firstObject];
        
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
    return [[SASDevice deviceNames] count];
}



#pragma UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SASFilterViewCell *sasFilterViewCell = (SASFilterViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"sasFilterViewCell"];
    
    sasFilterViewCell.associatedDevice.type = indexPath.row;
    
    sasFilterViewCell.deviceNameLabel.text = [SASDevice deviceNames][indexPath.row];
    
    sasFilterViewCell.imageView.image = [SASDevice deviceImages][indexPath.row];
    
    return sasFilterViewCell;
}



- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(selectedCellsAssociatedDevice == nil) {
        selectedCellsAssociatedDevice = [[NSMutableArray alloc] init];
    }
    

    SASFilterViewCell *selectedCell = (SASFilterViewCell*)[aTableView cellForRowAtIndexPath:indexPath];
    [selectedCell updateSelectionStatus];
    //[self.selectedCellsAssociatedDevice addObject:selectedCell.associatedDevice];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




// TODO: Add logic for what cells can be selected together etc.
// Forwards selected cells associatedDevice to delegate.
- (IBAction)doneButtonPressed:(id)sender {
    if(delegate != nil && [delegate respondsToSelector:@selector(sasFilterView:doneButtonWasPressedWithDevicesSelected:)]) {
        [self.delegate sasFilterView:self doneButtonWasPressedWithDevicesSelected:self.selectedCellsAssociatedDevice];
    }
}



#pragma Animations
// Animates into the views center.
- (void) animateIntoView:(UIView*) view {
    
    
    [UIView animateWithDuration:0.4
                          delay:0.1
         usingSpringWithDamping:0.6
          initialSpringVelocity:.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){ self.center = view.center;}
                     completion:nil];
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
                     completion:nil];
}

@end
