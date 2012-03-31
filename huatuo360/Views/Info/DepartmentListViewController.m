//
//  DepartmentListViewController.m
//  huatuo360
//
//  Created by Zhao Ange on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DepartmentListViewController.h"
#import "HospitalListViewController.h"
#import "DoctorListViewController.h"
#import "Constants.h"

@implementation DepartmentListViewController
@synthesize params;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
        firstAppear = true;
        total = 0;
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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)loadData:(NSDictionary *)data
{
    NSLog(@"%@", data);
    total = [[data objectForKey:@"total"]integerValue];
    NSLog(@"%i", total);
    if(nil == listData)
        listData = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dict = [data objectForKey:@"data"];
    for (NSString *key in dict)
    {
        NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
        [tmp setObject:key forKey:@"id"];
        [tmp setObject:[dict objectForKey: key] forKey:@"name"];
        [listData addObject:tmp];
    }
    [self.listView reloadData];    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.tableTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    if (row == [listData count]) {
        [self nextPage];
        return;
    }
    //要判断入口事医院排行还是医生排行来决定请求那个接口
    NSMutableDictionary *itemData = [listData objectAtIndex:row];
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmp setObject:@"1" forKey:@"page"];
    [tmp setObject:[itemData objectForKey:@"id"] forKey:@"deptid"];
    [tmp setObject:[itemData objectForKey:@"name"] forKey:@"_name"];//设置附加参数
    if([params objectForKey:@"_hospital"]){
        [tmp setObject:_hospitalList forKey:@"interfaceName"];
        HospitalListViewController* hlvc = [[HospitalListViewController alloc] init];
        hlvc.params = tmp;
        hlvc.tableTitle = [[NSString alloc]initWithFormat:@"%@医院排行", [itemData objectForKey:@"name"]];
        [self.navigationController pushViewController:hlvc animated:true];
    }else if([params objectForKey:@"_doctor"]){
        [tmp setObject:_doctorList forKey:@"interfaceName"];
        DoctorListViewController* dlvc = [[DoctorListViewController alloc] init];
        dlvc.params = tmp;
        dlvc.tableTitle = [[NSString alloc]initWithFormat:@"%@医生排行", [itemData objectForKey:@"name"]];
        [self.navigationController pushViewController:dlvc animated:true];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}

- (NSString*)getTitleByIndex:(int)index
{
    return [[listData objectAtIndex:index] objectForKey:@"name"];
}

- (void)nextPage
{
    NSString *pageText = [[NSString alloc]initWithFormat:@"%i", ++page];
    [params setObject:pageText forKey:@"page"];
    
    [[AsiObjectManager sharedManager] setDelegate:self];
    [[AsiObjectManager sharedManager] requestData:params];
}

@end
