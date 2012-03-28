//
//  DoctorListViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DoctorListViewController.h"
#import "Constants.h"


@implementation DoctorListViewController
@synthesize params;
extern NSString* const _departmentList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
        firstAppear = true;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(firstAppear)
    {
        firstAppear = false;
        [[AsiObjectManager sharedManager] setDelegate:self];
        [[AsiObjectManager sharedManager] requestData:params];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    int row = [indexPath row];
    if (row == [listData count]) {
        [self nextPage];
        return;
    }
}

- (NSString*)getTitleByIndex:(int)index
{
    return [[listData objectAtIndex:index] objectForKey:@"name"];
}

- (NSString*)getIntroByIndex:(int)index
{
    return [[listData objectAtIndex:index] objectForKey:@"info"];
}

- (void)nextPage
{
    NSString *pageText = [[NSString alloc]initWithFormat:@"%i", ++page];
    [params setObject:pageText forKey:@"page"];
    
    [[AsiObjectManager sharedManager] setDelegate:self];
    [[AsiObjectManager sharedManager] requestData:params];
}

@end
