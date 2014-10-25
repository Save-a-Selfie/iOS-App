//
//  IntroViewController.m
//  Save a Selfie 2
//
//  Created by Peter FitzGerald on 18/10/2014.
//  Copyright (c) 2014 Peter FitzGerald. All rights reserved.
//

#import "IntroViewController.h"
#import "TabBarController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController
int chosenSegment;

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBarController.tabBar.hidden = YES;
//    NSArray *ary = [self.tabBarController viewControllers];
//    NSLog(@"tab bar controllers: %@", ary);
    // Do any additional setup after loading the view.
}

-(IBAction)choiceChosen:(UISegmentedControl *)sender
{
//    NSArray *ary = [self.tabBarController viewControllers];
//    self.tabBarController.tabBar.hidden = NO;
//    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
////    [controllers removeObjectAtIndex:0];
////    [self.tabBarController setViewControllers:controllers animated:YES];
////    ary = [self.tabBarController viewControllers];
////    NSLog(@"tab bar controllers: %@", ary);
//    
//    NSMutableArray *items = [NSMutableArray arrayWithArray:self.tabBarController.tabBar.items];
//    [items removeObjectAtIndex:0];
//    [self.tabBarController.tabBar setItems:items];
//    ary = [self.tabBarController viewControllers];
//    NSLog(@"tab bar controllers: %@", ary);
    
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TabBarController *tabViewController = (TabBarController *) [mainStoryBoard instantiateViewControllerWithIdentifier:@"TabBarController"];

    
    switch (self.choose.selectedSegmentIndex)
    {
        case 0:
            plog(@"Snap");
            chosenSegment = 0;
            self.navigationController.viewControllers = [NSArray arrayWithObject: tabViewController];
            self.tabBarController.selectedIndex = chosenSegment;
            break;
        case 1:
            plog(@"Map");
            chosenSegment = 1;
            self.navigationController.viewControllers = [NSArray arrayWithObject: tabViewController];
            self.tabBarController.selectedIndex = chosenSegment;
            break;
        default: 
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showUpload:(id)sender {
}

- (IBAction)showWebsite:(id)sender {
}
@end
