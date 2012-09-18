//
//  HospitalListViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HospitalListViewController.h"
//#import "DoctorListVC.h"
#import "DoctorListVC.h"
#import "Constants.h"
#import "HUDManger.h"

#import "CityListVC.h"

@interface HospitalListViewController ()

@end

@implementation HospitalListViewController
@synthesize params, diseaseName;

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
        
        //city select
        btnCity = [[UIBarButtonItem alloc] initWithTitle:gcityName style:UIBarButtonItemStylePlain target:self action:@selector(showCityList)];
        self.navigationItem.rightBarButtonItem = btnCity;
        
//        UIBarButtonItem *btnCity = [[UIBarButtonItem alloc] init];
//        btnCity.title = gcityName;
//        [self.navigationItem setRightBarButtonItem:btnCity];
    }
    return self;
}

- (void)showCityList
{
    CityListVC* cityListVC = [[CityListVC alloc]init];
    [cityListVC setDelegate:self];
    [self.navigationController pushViewController:cityListVC animated:YES];
}

- (void) selectCity:(NSString*)cityId cityName:(NSString*)cityName
{
    if (![gcityId isEqualToString:cityId] && cityName != nil)
    {
        btnCity.title = cityName;
        gcityId = cityId;
        gcityName = cityName;
        
        [self update];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(firstAppear)
    {
        firstAppear = false;
        [params setObject:_hospitalList forKey:@"interfaceName"];
        [params setObject:@"1" forKey:@"page"];
        manager = [AsiObjectManager alloc];
        [manager setDelegate:self];
        [manager requestData:params];
    }
    if(btnCity != nil)
        btnCity.title = gcityName;
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
    [listData addObjectsFromArray:[data objectForKey:@"data"]];
    [self.listView reloadData];
}

- (void) requestFailed:(NSError*)error
{
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
    NSMutableDictionary *itemData = [listData objectAtIndex:row];
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
    DoctorListVC* dlvc = [[DoctorListVC alloc]init];
    [tmp setObject:[itemData objectForKey:@"id"] forKey:@"hospid"];
    [tmp setObject:[itemData objectForKey:@"name"] forKey:@"_name"];//医院名字
    //常见疾病排名，搜索疾病
    if([params objectForKey:@"_diseaseid"])//疾病id
    {
        [tmp setObject:[params objectForKey:@"_diseaseid"] forKey:@"diseaseid"];
    }
    
    //各科室医院排名
    if([params objectForKey:@"deptid"] && ![params objectForKey:@"_diseaseid"])//科室id
        [tmp setObject:[params objectForKey:@"deptid"] forKey:@"deptid"];
    dlvc.params = tmp;
    if([params objectForKey:@"_name"])
    {
        dlvc.tableTitle = [[NSString alloc]initWithFormat:@"%@%@的医生", [itemData objectForKey:@"name"], [params objectForKey:@"_name"]];
    }
    else
        dlvc.tableTitle = [[NSString alloc]initWithFormat:@"%@的医生", [itemData objectForKey:@"name"]];
    dlvc.hospitalName = [itemData objectForKey:@"name"];
    dlvc.diseaseName = diseaseName;
    [self.navigationController pushViewController:dlvc animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}

- (NSString*)getTitleByIndex:(int)index
{
    return [[listData objectAtIndex:index] objectForKey:@"name"];
}

- (NSString*)getIntroByIndex:(int)index
{
    NSDictionary* itemData = [listData objectAtIndex:index];
    NSString *intro = [[NSString alloc]initWithFormat:@"%@  %@", [itemData objectForKey:@"level"],[itemData objectForKey:@"addr"]];
    return intro;
//    return NSstring all    [itemData objectForKey:@"level"] + @" " + [itemData objectForKey:@"addr"];
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
