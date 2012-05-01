//
//  DoctorListVC.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DoctorListViewController.h"
#import "Constants.h"
#import "DoctorDetailVC.h"
#import "HospitalDetailVC.h"

@implementation DoctorListViewController
@synthesize params;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization test
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
        [params setObject:_doctorList forKey:@"interfaceName"];
        [params setObject:@"1" forKey:@"page"];
        manager = [AsiObjectManager alloc];
        [manager setDelegate:self];
        [manager requestData:params];
        NSLog(@"params=%@",params); 
        if([params objectForKey:@"hospid"]){//从医院列表过来的医生列表
            //医院详情按钮
            btnDetail  = [[UIBarButtonItem alloc] initWithTitle:@"医院详情" style:UITabBarSystemItemContacts target:self action:@selector(showCommentView)];
            [self.navigationItem setRightBarButtonItem:btnDetail];
        }
        [btnDetail setEnabled:FALSE];
    }
}

- (void)showCommentView
{
    //NSLog(@"医院详情");
    NSString* hospitalId = [params objectForKey:@"hospid"];
    NSString* hospitalName = [params objectForKey:@"_name"];
    HospitalDetailVC* hdvc = [[HospitalDetailVC alloc]initWithHospId:hospitalId hname:hospitalName];
    [self.navigationController pushViewController:hdvc animated:true];; 
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
    [btnDetail setEnabled:TRUE];
}

- (void) requestFailed:(NSError*)error
{
    [btnDetail setEnabled:TRUE];
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
    
    NSMutableDictionary *itemData = [listData objectAtIndex:row];
    NSString* doctorId = [itemData objectForKey:@"id"];
    NSString* doctorName = [itemData objectForKey:@"name"];
    DoctorDetailVC* ddvc = [[DoctorDetailVC alloc]initWithDoctorId:doctorId dname:doctorName];
    [self.navigationController pushViewController:ddvc animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
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
    [manager requestData:params];
}

- (void)update
{
    listData = nil;
    [params setObject:@"1" forKey:@"page"];
    page = 1;
    if (nil != manager) 
        [manager requestData:params];
    [self.listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
@end
