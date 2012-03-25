//
//  InfoViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InfoNavViewController.h"
#import "HospitalListViewController.h"
#import "DoctorListViewController.h"
@interface InfoNavViewController ()

@end

@implementation InfoNavViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Info", @"Infomation");
        self.tabBarItem.image = [UIImage imageNamed:@"info"]; 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    HospitalListViewController* hospitalListVC = [[HospitalListViewController alloc] initWithNibName:@"ListView" bundle:nil];
//    self.viewControllers = [[NSArray alloc]initWithObjects:hospitalListVC, nil];}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HospitalListViewController* hospitalListVC = [[HospitalListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    //    DoctorListViewController* doctorListVC = [[DoctorListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    self.viewControllers = [[NSArray alloc]initWithObjects:hospitalListVC, nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
