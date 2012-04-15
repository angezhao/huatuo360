//
//  InfoViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InfoNavViewController.h"
#import "Constants.h"
#import "HospitalListViewController.h"
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(nil == infoViewToShow)
    {
        if(self.viewControllers == nil || [self.viewControllers count] == 0)
        {               
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
            [params setObject:_hospitalList forKey:@"interfaceName"];
            [params setObject:@"1" forKey:@"page"];
            HospitalListViewController* hlvc = [[HospitalListViewController alloc]init];
            hlvc.params = params;
            hlvc.tableTitle = @"医院排行";
            NSLog(@"count = %i", [self.viewControllers count]);
        }
    }
    else 
    {
        self.viewControllers = [[NSArray alloc]initWithObjects:infoViewToShow, nil]; 
        infoViewToShow = nil;
    }
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
