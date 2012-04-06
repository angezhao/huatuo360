//
//  HospitalListViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HospitalListViewController.h"
#import "DoctorListViewController.h"
#import "Constants.h"

@interface HospitalListViewController ()

@end

@implementation HospitalListViewController
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
        manager = [AsiObjectManager alloc];
        [manager setDelegate:self];
        [manager requestData:params];
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
    [listData addObjectsFromArray:[data objectForKey:@"data"]];
    [self.listView reloadData];    
}

- (void) requestFailed:(NSError*)error{

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
    [tmp setObject:_doctorList forKey:@"interfaceName"];
    [tmp setObject:@"1" forKey:@"page"];
    [tmp setObject:[itemData objectForKey:@"id"] forKey:@"hospid"];
    [tmp setObject:[itemData objectForKey:@"name"] forKey:@"_name"];//医院名字
    if([params objectForKey:@"_diseaseid"])//疾病id
        [tmp setObject:[params objectForKey:@"_diseaseid"] forKey:@"diseaseid"];
    if([params objectForKey:@"deptid"] && ![params objectForKey:@"_diseaseid"])//科室id
        [tmp setObject:[params objectForKey:@"deptid"] forKey:@"deptid"];
    DoctorListViewController* dlvc = [[DoctorListViewController alloc]init];
    dlvc.params = tmp;
    if([params objectForKey:@"_name"])
        dlvc.tableTitle = [[NSString alloc]initWithFormat:@"%@%@的医生", [itemData objectForKey:@"name"], [params objectForKey:@"_name"]];
    else
        dlvc.tableTitle = [[NSString alloc]initWithFormat:@"%@的医生", [itemData objectForKey:@"name"]];
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
@end
