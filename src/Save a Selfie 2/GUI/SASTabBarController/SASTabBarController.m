//
//  TabBarController.m
//  Save a Selfie 2
//
//  Created by Nadja Deininger and Peter FitzGerald
//  GNU General Public License
//

#import "SASTabBarController.h"
#import "AppDelegate.h"
#import "SASColour.h"

@interface SASTabBarController ()

@end

@implementation SASTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15.0f]
       }forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
