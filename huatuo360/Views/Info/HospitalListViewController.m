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
    total = (int)[data objectForKey:@"total"];
    [listData addObjectsFromArray:[data objectForKey:@"data"]];
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
    NSMutableDictionary *itemData = [listData objectAtIndex:row];
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmp setObject:_doctorList forKey:@"interfaceName"];
    [tmp setObject:@"1" forKey:@"page"];
    [tmp setObject:[itemData objectForKey:@"id"] forKey:@"hospid"];
    DoctorListViewController* dlvc = [[DoctorListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    dlvc.params = tmp;
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
    
    [[AsiObjectManager sharedManager] setDelegate:self];
    [[AsiObjectManager sharedManager] requestData:params];
}
@end
