//
//  HospitalListViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HospitalListViewController.h"
#import "DoctorListViewController.h"

@interface HospitalListViewController ()

@end

@implementation HospitalListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        listData = [[NSArray alloc]initWithObjects: 
        @"医院1",
        @"医院2",
        @"医院3",
        @"医院4",
        @"医院5", nil];
        
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
    }
    return self;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"医院综合排名";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorListViewController* doctorListVC = [[DoctorListViewController alloc] initWithNibName:@"ListView" bundle:nil];
    [self.navigationController pushViewController:doctorListVC animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}

@end
