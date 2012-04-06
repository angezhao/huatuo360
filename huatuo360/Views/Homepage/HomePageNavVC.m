//
//  HomePageNavVC.m
//  huatuo360
//
//  Created by Alpha Wong on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomePageNavVC.h"
#import "CityListVC.h"
#import "HomepageViewController.h"

@interface HomePageNavVC ()

@end

@implementation HomePageNavVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Homepage", @"Homepage");
        self.tabBarItem.image = [UIImage imageNamed:@"homepage"];
    }
    return self;
}

- (void)viewDidLoad
{    
    HomepageViewController* clv = [[HomepageViewController alloc] initWithNibName:@"HomepageViewController" bundle:nil];
    self.viewControllers = [[NSArray alloc]initWithObjects:clv, nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
