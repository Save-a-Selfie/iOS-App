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

@property (strong, nonatomic) NSMutableArray *cells;

@end

@implementation SASFilterView

@synthesize tableView = _tableView;
@synthesize filterLabel;
@synthesize delegate;
@synthesize selectedDevice = _selectedDevice;
@synthesize cells;

SASDeviceType availableDevicesToFilter[5] = {
    All,
    Defibrillator,
    LifeRing,
    FirstAidKit,
    FireHydrant
};



#pragma mark Object Life Cycle.
- (instancetype)init {
    
    if(self = [super init]) {
        
       self = [[[NSBundle mainBundle]
                loadNibNamed:@"SASFilterView"
                owner:self
                options:nil]
               firstObject];
        
        
        [UIFont increaseCharacterSpacingForLabel:self.filterLabel byAmount:2.3];
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;

        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 8.0;

        
        
        // Register SASFilterViewCell.
        [_tableView registerNib:[UINib nibWithNibName:@"SASFilterViewCell" bundle:nil]
             forCellReuseIdentifier:@"sasFilterViewCell"];
        
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _selectedDevice = All;
    }
    return self;
}




#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sizeof(availableDevicesToFilter) / sizeof(int);
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (SASFilterViewCell *sasFilterViewCell in cells) {
        [self untickCell:sasFilterViewCell];
    }
    
    SASFilterViewCell *selectedCell = (SASFilterViewCell*)[aTableView cellForRowAtIndexPath:indexPath];
    [self tickCell:selectedCell];
    self.selectedDevice = selectedCell.associatedDeviceType;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (void) untickCell:(SASFilterViewCell*) cell {
    [cell setCellWithGreenTick:NO];
}


- (void) tickCell: (SASFilterViewCell*) cell {
    [cell setCellWithGreenTick:YES];
}




#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SASDeviceType deviceTypeForCell = [self getDeviceForCellWithIndexPath:indexPath];
    
    if(self.cells == nil) {
        self.cells = [[NSMutableArray alloc] init];
    }
    
    SASFilterViewCell *sasFilterViewCell = (SASFilterViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"sasFilterViewCell"];
    sasFilterViewCell.deviceNameLabel.text = [SASDevice getDeviceNameForDeviceType:deviceTypeForCell];
    sasFilterViewCell.imageView.image = [SASDevice getDeviceImageForDeviceType:deviceTypeForCell];
    sasFilterViewCell.associatedDeviceType = deviceTypeForCell;
    
    // This should be by default the cell which is selected i.e
    // has green tick.
    if(deviceTypeForCell == All) {
        [self tickCell:sasFilterViewCell];
    }
    
    // Keep reference to each cell.
    [self.cells addObject:sasFilterViewCell];
    
    return sasFilterViewCell;
}



- (SASDeviceType) getDeviceForCellWithIndexPath:(NSIndexPath*) indexPath {
    
    SASDeviceType deviceTypeForCell = All;
    
    switch (indexPath.row) {
        case 0:
            deviceTypeForCell = All;
            break;
            
        case 1:
            deviceTypeForCell = Defibrillator;
            break;
            
        case 2:
            deviceTypeForCell = LifeRing;
            break;
            
        case 3:
            deviceTypeForCell = FirstAidKit;
            break;
            
        case 4:
            deviceTypeForCell = FireHydrant;
            break;
            
        default:
            break;
    }
    
    return deviceTypeForCell;
}



// Forwards selected cells associatedDevice to delegate.
- (IBAction)doneButtonPressed:(id)sender {
    if(delegate != nil && [delegate respondsToSelector:@selector(sasFilterView:doneButtonWasPressedWithSelectedDeviceType:)]) {
        [self.delegate sasFilterView:self doneButtonWasPressedWithSelectedDeviceType:self.selectedDevice];
    }
}


- (void) updateDelegateOnViewVisibility:(BOOL) visibility {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sasFilterView:isVisibleInViewHierarhy:)]) {
        [self.delegate sasFilterView:self isVisibleInViewHierarhy:visibility];
    }
}



#pragma mark Animations
// Animates into the views center.
- (void) animateIntoView:(UIView*) view {
    [view addSubview:self];
    
    self.center = view.center;
    
    [UIView animateWithDuration:0.5
                          delay:0.1
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{CGAffineTransform transform = CGAffineTransformMakeScale(1.02, 1.02);
                         self.transform = transform;
                         
                     }
                     completion:^(BOOL visible){[self updateDelegateOnViewVisibility:YES];}];
    

}



- (void) animateOutOfView {
    [self removeFromSuperview];
    [self updateDelegateOnViewVisibility:NO];
    
    // Change the scale back to 1.
    self.transform = CGAffineTransformMakeScale(1, 1);
    
}





@end
