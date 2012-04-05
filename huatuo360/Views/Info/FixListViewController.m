//
//  FixListViewController.m
//  huatuo360
//
//  Created by Zhao Ange on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FixListViewController.h"
#import "HospitalListViewController.h"
#import "DoctorListViewController.h"
#import "Constants.h"

@implementation FixListViewController
@synthesize params;
extern NSString* const _departmentList;

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
        listData = [[NSMutableArray alloc]initWithObjects: 
                    @"专治医生排行",
                    @"医院排行",
                    @"相关日志排行", nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(firstAppear)
    {
        firstAppear = false;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [listData objectAtIndex:row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    switch ([indexPath row]) 
    {
        case 0:
            {
                NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
                [tmp setObject:_doctorList forKey:@"interfaceName"];
                [tmp setObject:@"1" forKey:@"page"];
                [tmp setObject:[params objectForKey:@"diseaseid"] forKey:@"diseaseid"];
                DoctorListViewController* dlvc = [[DoctorListViewController alloc]init];
                dlvc.params = tmp;
                dlvc.tableTitle = @"医生排行";
                infoViewToShow = dlvc;
                [self.navigationController pushViewController:dlvc animated:true];
            }  
            break;
        case 1:
            {
                NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
                [tmp setObject:_hospitalList forKey:@"interfaceName"];
                [tmp setObject:@"1" forKey:@"page"];
                [tmp setObject:[params objectForKey:@"diseaseid"] forKey:@"deptid"];
                [tmp setObject:[params objectForKey:@"diseaseid"] forKey:@"_diseaseid"];
                HospitalListViewController* hlvc = [[HospitalListViewController alloc]init];
                hlvc.params = tmp;
                hlvc.tableTitle = @"医院排行";
                infoViewToShow = hlvc;
                [self.navigationController pushViewController:hlvc animated:true];

            }  
            break;
        default:
            break;
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

@end
