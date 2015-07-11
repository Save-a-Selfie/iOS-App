//
//  EmergencyObjects.h
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 02/11/2014.
//  Copyright (c) 2014 Peter FitzGerald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyObjects : UIView

@property (strong, nonatomic) IBOutlet UIButton *EmObj1;
@property (strong, nonatomic) IBOutlet UIButton *EmObj2;
@property (strong, nonatomic) IBOutlet UIButton *EmObj3;
@property (strong, nonatomic) IBOutlet UIButton *EmObj4;
//@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UILabel *background1;
@property (weak, nonatomic) IBOutlet UILabel *background2;
@property (weak, nonatomic) IBOutlet UILabel *background3;
@property (weak, nonatomic) IBOutlet UILabel *background4;
- (IBAction)EmObjTapped:(id)sender;
- (IBAction)EmergencyObjectsViewLoaded;
@end
