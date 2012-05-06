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
#import "CityListVC.h"

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
            [self setupBackToHomepageButton:hlvc];
            hlvc.params = params;
            hlvc.tableTitle = @"医院排行";
            
            showingVC = hlvc;
            self.viewControllers = [[NSArray alloc]initWithObjects:hlvc, nil];
        }
    }
    else 
    {
        showingVC = infoViewToShow;
        [self setupBackToHomepageButton:infoViewToShow];
        self.viewControllers = [[NSArray alloc]initWithObjects:infoViewToShow, nil]; 
        infoViewToShow = nil;
    }
    if(btnCity != nil)
        btnCity.title = gcityName;
}

- (void)setupBackToHomepageButton:(UIViewController*)showView
{
//    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
//    [backButton addTarget:self action:@selector(backToHomepage) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    
//    // create button item -- possible because UIButton subclasses UIView!
//    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    showView.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(backToHomepage)];
    showView.navigationItem.leftBarButtonItem = back;
    
    btnCity = [[UIBarButtonItem alloc] initWithTitle:gcityName style:UIBarButtonItemStylePlain target:self action:@selector(showCityList)];
    showView.navigationItem.rightBarButtonItem = btnCity;
}

- (void)backToHomepage
{
    [self.tabBarController setSelectedIndex:0];
}

- (void)showCityList
{
    CityListVC* cityListVC = [[CityListVC alloc]init];
    [cityListVC setDelegate:self];
    [showingVC.navigationController pushViewController:cityListVC animated:YES];
}

- (void) selectCity:(NSString*)cityId cityName:(NSString*)cityName
{
    if (![gcityId isEqualToString:cityId] && cityName != nil)
    {
        btnCity.title = cityName;
        gcityId = cityId;
        gcityName = cityName;
        
        if([showingVC respondsToSelector:@selector(update)])
            [showingVC performSelector:@selector(update)];
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
