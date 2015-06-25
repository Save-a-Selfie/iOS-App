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
#import "Device.h"
#import "SASFilterViewCell.h"


@interface SASFilterView() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SASFilterView

@synthesize tableView;
@synthesize delegate;

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
    }
    return self;
}


#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Device deviceNames] count];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SASFilterViewCell *selectedCell = (SASFilterViewCell*)[aTableView cellForRowAtIndexPath:indexPath];
    selectedCell.selectionStatus = YES;
    
    DeviceType selectedDevice = All;

    switch (indexPath.row) {
        case 0:
            selectedDevice = Defibrillator;
            break;
            
        case 1:
            selectedDevice = LifeRing;
            break;
            
        case 2:
            selectedDevice = FirstAidKit;
            break;
            
        case 3:
            selectedDevice = FireHydrant;
            break;
            
        case 4:
            selectedDevice = All;
            break;
            
        default:
            break;
    }
    
    [self tableViewCellSelected:selectedDevice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SASFilterViewCell *sasFilterViewCell = (SASFilterViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"sasFilterViewCell"];
    sasFilterViewCell.selectionStatus = NO;
    sasFilterViewCell.deviceName.text = [Device deviceNames][indexPath.row];
    sasFilterViewCell.imageView.image = [Device deviceImages][indexPath.row];
    return sasFilterViewCell;
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



- (void) tableViewCellSelected:(DeviceType) deviceType {

    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(sasFilterView:buttonWasPressed:)]) {
        [self.delegate sasFilterView:self buttonWasPressed:deviceType];
    }
}



@end
