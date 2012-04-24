//
//  AppDelegate.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "HomePageNavVC.h"
#import "HomepageViewController.h"
#import "InfoNavViewController.h"
#import "MoreViewController.h"
#import "UserNavViewController.h"

#import "AsiObjectManager.h"
#import "Constants.h"

#import "CityListVC.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void) initConfigData {
    //init cityid and userid
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSDictionary* data = [[NSDictionary alloc] initWithContentsOfFile:path];
    gcityId = [data objectForKey:@"cityid"];
    if([gcityId isEqualToString:@""])
        gcityId = @"2001";
    gcityName = [data objectForKey:@"cityname"];
    if([gcityName isEqualToString:@""])
        gcityName = @"北京";
    userId = [data objectForKey:@"userid"];
    if(![userId isEqualToString:@""])
        isLogin = true;
    email = [data objectForKey:@"email"];
    NSLog(@"%@",userId);
    //NSLog(@"%@",isLogin);
    NSLog(@"%@",gcityId);
    NSLog(@"%@",gcityName);
    //init departmentlist数据
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
//    [params setObject:_departmentList forKey:@"interfaceName"];
//    AsiObjectManager* manager = [AsiObjectManager alloc];
//    NSDictionary* data = [manager syncRequestData:params];
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
//    [params setObject:_departmentList forKey:@"interfaceName"];
//    AsiObjectManager* manager = [AsiObjectManager alloc];
//    departments = [manager syncRequestData:params];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initConfigData];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.    
    HomePageNavVC *viewController1 = [[HomePageNavVC alloc] init];
//    UIViewController *viewController1 = [[HomepageViewController alloc] initWithNibName:@"HomepageViewController" bundle:nil];
    UIViewController *viewController2 = [[InfoNavViewController alloc] init];
    UIViewController *viewController3 = [[UserNavViewController alloc] init];
    UIViewController *viewController4 = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, viewController3, viewController4, nil];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //保存数据
    [self saveData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //保存数据
    [self saveData];
}

- (void)saveData
{
    //保存变量数据cityid,cityname,userid
    NSString* savePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSMutableDictionary* saveData = [NSMutableDictionary dictionaryWithCapacity:0];
    [saveData setObject:gcityId forKey:@"cityid"];
    [saveData setObject:gcityName forKey:@"cityname"];
    [saveData setObject:userId forKey:@"userid"];
    [saveData setObject:email forKey:@"email"];
    [saveData writeToFile:savePath atomically:YES];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
