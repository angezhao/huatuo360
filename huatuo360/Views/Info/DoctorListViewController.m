//
//  DoctorListViewController.m
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
        [[AsiObjectManager sharedManager] setDelegate:self];
        [[AsiObjectManager sharedManager] requestData:params];
        NSLog(@"params=%@",params); 
        if([params objectForKey:@"hospid"]){//从医院列表过来的医生列表
            //医院详情按钮
            UIBarButtonItem *btnComment  = [[UIBarButtonItem alloc] initWithTitle:@"医院详情" style:UITabBarSystemItemContacts target:self action:@selector(showCommentView)];
            [self.navigationItem setRightBarButtonItem:btnComment];
        }
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
    
    NSMutableDictionary *itemData = [listData objectAtIndex:row];
//    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
//    [tmp setObject:_doctor forKey:@"interfaceName"];
//    [tmp setObject:@"1" forKey:@"page"];
//    [tmp setObject:[itemData objectForKey:@"id"] forKey:@"id"];
    
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
    [[AsiObjectManager sharedManager] setDelegate:self];
    [[AsiObjectManager sharedManager] requestData:params];
}

@end
