//
//  CommentListViewController.m
//  huatuo360
//
//  Created by Zhao Ange on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentViewController.h"
#import "LoginViewController.h"
#import "Constants.h"

@interface CommentListViewController ()

@end

@implementation CommentListViewController
@synthesize params;
- (id)init
{
    self = [super init];
    if (self) {
        displayerNext = false;
        // Custom initialization
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
        firstAppear = true;
        //评论按钮
        UIBarButtonItem *btnComment  = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UITabBarSystemItemContacts target:self action:@selector(showCommentView)];
        [self.navigationItem setRightBarButtonItem:btnComment];
    }
    return self;
}

- (void)showCommentView
{
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmp setObject:self.tableTitle forKey:@"_name"];
    if([params objectForKey:@"hospid"])
        [tmp setObject:[params objectForKey:@"hospid"] forKey:@"hospid"];
    else
        [tmp setObject:[params objectForKey:@"doctorid"] forKey:@"doctorid"];
    
    if(isLogin){//判断是否已经登陆
        CommentViewController* cvc = [[CommentViewController alloc]init];
        cvc.params = tmp;
        [self.navigationController pushViewController:cvc animated:TRUE];
    }else {//转登陆页
        LoginViewController* lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        lvc.params = tmp;
        userViewToShow = lvc;
        lastInfoView = self;
        [self.tabBarController setSelectedIndex:2];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(firstAppear)
    {
        firstAppear = false;
        [params setObject:_commentList forKey:@"interfaceName"];
        [params setObject:@"1" forKey:@"page"];
        manager = [AsiObjectManager alloc];
        [manager setDelegate:self];
        [manager requestData:params];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadData:(NSDictionary *)data
{
    total = [[data objectForKey:@"total"]integerValue];
    if(nil == listData)
        listData = [[NSMutableArray alloc]initWithCapacity:0];
    [listData addObjectsFromArray:[data objectForKey:@"data"]];
    [self.listView reloadData]; 
}

- (void) requestFailed:(NSError*)error{
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.tableTitle;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSString*)getTitleByIndex:(int)index
{
   return [listData objectAtIndex:index];
}

- (void)nextPage
{
    NSString *pageText = [[NSString alloc]initWithFormat:@"%i", ++page];
    [params setObject:pageText forKey:@"page"];
    [manager requestData:params];
}

@end
