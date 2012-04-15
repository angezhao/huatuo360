//
//  DiseaseListViewController.m
//  huatuo360
//
//  Created by Zhao Ange on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DiseaseListViewController.h"
#import "HospitalListViewController.h"
#import "DoctorListVC.h"
#import "FixListViewController.h"
#import "Constants.h"

@implementation DiseaseListViewController
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
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(firstAppear)
    {
        firstAppear = false;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    int row = [indexPath row];
    if (row == [listData count]) {
        [self nextPage];
        return;
    }
    //要判断入口是医院排行还是医生排行来决定请求那个接口－出口3个：医生列表，医院列表，固定页
    NSMutableDictionary *itemData = [listData objectAtIndex:row];
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
    if([params objectForKey:@"_hospital"]){
        [tmp setObject:_hospitalList forKey:@"interfaceName"];
        [tmp setObject:[itemData objectForKey:@"id"] forKey:@"deptid"];
        [tmp setObject:[itemData objectForKey:@"id"] forKey:@"_diseaseid"];
        [tmp setObject:@"1" forKey:@"page"];
        HospitalListViewController* hlvc = [[HospitalListViewController alloc]init];
        hlvc.params = tmp;
        hlvc.tableTitle = @"常见疾病";
        [self.navigationController pushViewController:hlvc animated:true];
    }else if([params objectForKey:@"_doctor"]){
        [tmp setObject:_doctorList forKey:@"interfaceName"];
        [tmp setObject:[itemData objectForKey:@"id"] forKey:@"diseaseid"];
        [tmp setObject:@"1" forKey:@"page"];
        DoctorListVC* dlvc = [[DoctorListVC alloc]init];
        dlvc.params = tmp;
        dlvc.tableTitle = @"常见疾病";
        [self.navigationController pushViewController:dlvc animated:true];
    }else {
        [tmp setObject:[itemData objectForKey:@"id"] forKey:@"diseaseid"];
        //[tmp setObject:[itemData objectForKey:@"name"] forKey:@"name"];
        FixListViewController* flvc = [[FixListViewController alloc]init];
        flvc.params = tmp;
        flvc.tableTitle = [[NSString alloc]initWithFormat:@"%@", [itemData objectForKey:@"name"]];
        [self.navigationController pushViewController:flvc animated:true];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSString*)getTitleByIndex:(int)index
{
    NSDictionary* itemData = [listData objectAtIndex:index];
    NSString *info = [[NSString alloc]initWithFormat:@"%@（%@）", [itemData objectForKey:@"name"],[itemData objectForKey:@"department"]];
    return info;
}

- (void)nextPage
{
    NSString *pageText = [[NSString alloc]initWithFormat:@"%i", ++page];
    [params setObject:pageText forKey:@"page"];
    [manager requestData:params];
}
@end
