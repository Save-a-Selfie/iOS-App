//
//  SASFilterView.m
//  Save a Selfie
//
//  Created by Stephen Fox on 21/01/2016.
//  Copyright © 2016 Stephen Fox. All rights reserved.
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
@property (strong, nonatomic) SASMapView *filterableMapView;
@property (strong, nonatomic) NSMutableArray *cells;

@end

@implementation SASFilterView


SASDeviceType availableDevicesToFilter[5] = {
  SASDeviceTypeAll,
  SASDeviceTypeDefibrillator,
  SASDeviceTypeLifeRing,
  SASDeviceTypeFirstAidKit,
  SASDeviceTypeFireHydrant
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
    
    _selectedDevice = SASDeviceTypeAll;
  }
  return self;
}



- (void)mapToFilter:(SASMapView<MapFilterable>*) mapView {
  self.filterableMapView = mapView;
}


#pragma mark UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return sizeof(availableDevicesToFilter) / sizeof(int);
}


- (void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  for (SASFilterViewCell *sasFilterViewCell in self.cells) {
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
  
  SASFilterViewCell *sasFilterViewCell =
    (SASFilterViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"sasFilterViewCell"];
  sasFilterViewCell.deviceNameLabel.text =
    [SASDevice getDeviceNameForDeviceType:deviceTypeForCell];
  sasFilterViewCell.imageView.image = [SASDevice getDeviceImageForDeviceType:deviceTypeForCell];
  sasFilterViewCell.associatedDeviceType = deviceTypeForCell;
  
  // This should be by default the cell which is selected i.e
  // has green tick.
  if(deviceTypeForCell == SASDeviceTypeAll) {
    [self tickCell:sasFilterViewCell];
  }
  
  // Keep reference to each cell.
  [self.cells addObject:sasFilterViewCell];
  
  return sasFilterViewCell;
}



- (SASDeviceType) getDeviceForCellWithIndexPath:(NSIndexPath*) indexPath {
  
  SASDeviceType deviceTypeForCell = SASDeviceTypeAll;
  
  switch (indexPath.row) {
    case 0:
      deviceTypeForCell = SASDeviceTypeAll;
      break;
      
    case 1:
      deviceTypeForCell = SASDeviceTypeDefibrillator;
      break;
      
    case 2:
      deviceTypeForCell = SASDeviceTypeLifeRing;
      break;
      
    case 3:
      deviceTypeForCell = SASDeviceTypeFirstAidKit;
      break;
      
    case 4:
      deviceTypeForCell = SASDeviceTypeFireHydrant;
      break;
      
    default:
      break;
  }
  
  return deviceTypeForCell;
}



// Forwards selected cells associatedDevice to delegate.
- (IBAction) doneButtonPressed:(id)sender {
  // Message map on what to filter annotation to filter.
  [self.filterableMapView filterMapForDevice:self.selectedDevice];
  NSLog(@"%d", self.selectedDevice);
  [self animateOutOfParentView];
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
                   completion:nil];
  
  
}



- (void) animateOutOfParentView {
  [self removeFromSuperview];
  // Change the scale back to 1.
  self.transform = CGAffineTransformMakeScale(1, 1);
}





@end