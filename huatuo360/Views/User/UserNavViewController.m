//
//  UserViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserNavViewController.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "Constants.h"

@interface UserNavViewController ()

@end

@implementation UserNavViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"User", @"User");
        self.tabBarItem.image = [UIImage imageNamed:@"user"];
//        self.navigationController
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(nil == userViewToShow)
    {
        if(self.viewControllers == nil || [self.viewControllers count] == 0)
        {               
            if(!isLogin){
                LoginViewController* lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                self.viewControllers = [[NSArray alloc]initWithObjects:lvc, nil];
            }else {
                UserInfoViewController* uivc = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
                self.viewControllers = [[NSArray alloc]initWithObjects:uivc, nil];
            }
        }
    }
    else 
    {
       self.viewControllers = [[NSArray alloc]initWithObjects:userViewToShow, nil];   
       userViewToShow = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
