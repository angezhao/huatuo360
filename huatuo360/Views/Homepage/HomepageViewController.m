//
//  HomepageViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomepageViewController.h"
#import "HospitalListViewController.h"
#import "DepartmentListViewController.h"
#import "DiseaseListViewController.h"
#import "DoctorListVC.h"
#import "DoctorListViewController.h"
#import "Constants.h"
#import "DropDownList.h"
#import "CityListVC.h"

@implementation HomepageViewController
@synthesize searchBarRef, btnCity;
//@synthesize searchBarHolders;
const static int DISEASE = 0;
const static int HOSPITAL = 1;
const static int DOCTOR = 2;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
        //城市按钮
        btnCity  = [[UIBarButtonItem alloc] initWithTitle:gcityName style:UITabBarSystemItemContacts target:self action:@selector(showCityList)];
        [self.navigationItem setRightBarButtonItem:btnCity];
        
        listData = [[NSArray alloc]initWithObjects: 
                    @"医院综合排名",
                    @"各科室医院排名",
                    @"各科室医生排名",
                    @"常见疾病医院排名",
                    @"常见疾病医生排名", nil];
        searchBarHolders = [[NSArray alloc]initWithObjects:@"搜索病症", @"搜索医院", @"搜索医生", nil]; 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //读取持久化的数据赋值城市按钮的名字
    btnCity.title = @"全国";
    ddList = [[DropDownList alloc] initWithStyle:UITableViewStylePlain];
    ddList.delegate = searchBarRef;
    [ddList setParent:self.view];
//    [self.view addSubview:ddList.view];
//    [ddList setHidden:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
//    [ddList setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [searchBarRef resignFirstResponder];
    [searchBarRef setShowsCancelButton:NO animated:true];
    [ddList setHidden:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    [ddList setHidden:YES];
	[searchBar setShowsCancelButton:NO animated:true];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope 
{
    searchType = selectedScope;
    searchBar.placeholder = [searchBarHolders objectAtIndex:searchType];
    if (searchType != DISEASE) 
        [ddList setHidden:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    [self.tabBarController setSelectedIndex:3];
	[searchBar setShowsCancelButton:NO animated:true];
    [searchBar resignFirstResponder];
    
    switch (searchType) {
        case DISEASE:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:searchBar.text forKey:@"disease"];
                DiseaseListViewController* dlvc = [[DiseaseListViewController alloc]init];
                dlvc.params = params;
                dlvc.tableTitle = [[NSString alloc]initWithFormat:@"搜索\"%@\"的导医结果\n可能的疾病", searchBar.text];                
                infoViewToShow = dlvc;
                [self.tabBarController setSelectedIndex:1];
            }
            
            break;
        case HOSPITAL:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:searchBar.text forKey:@"hospital"];
                HospitalListViewController* hlvc = [[HospitalListViewController alloc]init];
                hlvc.params = params;
                hlvc.tableTitle = [[NSString alloc]initWithFormat:@"搜索\"%@\"的医院结果", searchBar.text];                
                infoViewToShow = hlvc;
                [self.tabBarController setSelectedIndex:1];
            }
            
            break;
        case DOCTOR:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:searchBar.text forKey:@"doctor"];
                DoctorListViewController* dlvc = [[DoctorListViewController alloc]init];
                dlvc.params = params;
                dlvc.tableTitle = [[NSString alloc]initWithFormat:@"搜索\"%@\"的医生结果", searchBar.text];                
                infoViewToShow = dlvc;
                [self.tabBarController setSelectedIndex:1];
            }
            
            break;     
        default:
            break;
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:true];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchType == DISEASE && [searchText length] != 0) 
    {
		[ddList update:searchText];
	}
	else 
    {
		[ddList setHidden:YES];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath row]) 
    {
        case 0:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                HospitalListViewController* hlvc = [[HospitalListViewController alloc]init];
                hlvc.params = params;
                hlvc.tableTitle = @"医院排行";
                infoViewToShow = hlvc;
                [self.tabBarController setSelectedIndex:1];
            }  
            break;
        case 1:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:@"1" forKey:@"_hospital"];
                DepartmentListViewController* dlvc = [[DepartmentListViewController alloc]init];
                dlvc.params = params;
                dlvc.tableTitle = @"科室排行";
                infoViewToShow = dlvc;
                [self.tabBarController setSelectedIndex:1];
            }  
            break;
        case 2:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:@"1" forKey:@"_doctor"];
                DepartmentListViewController* dlvc = [[DepartmentListViewController alloc]init];
                dlvc.params = params;
                dlvc.tableTitle = @"科室排行";
                infoViewToShow = dlvc;
                [self.tabBarController setSelectedIndex:1];
            }  
            break;
        case 3:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:@"1" forKey:@"_hospital"];
                DiseaseListViewController* dlvc = [[DiseaseListViewController alloc]init];
                dlvc.params = params;
                dlvc.tableTitle = @"常见疾病";
                infoViewToShow = dlvc;
                [self.tabBarController setSelectedIndex:1];
            }  
            break;
        case 4:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:@"1" forKey:@"_doctor"];
                DiseaseListViewController* dlvc = [[DiseaseListViewController alloc]init];
                dlvc.params = params;
                dlvc.tableTitle = @"常见疾病";
                infoViewToShow = dlvc;
                [self.tabBarController setSelectedIndex:1];
            }  
            break;
        default:
            break;
    }
    [self.tabBarController setSelectedIndex:1];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [searchBarRef resignFirstResponder];
    [searchBarRef setShowsCancelButton:NO animated:true];
    [ddList setHidden:YES];
}

- (void)showCityList
{
    if(nil == cityListVC)
    {
        cityListVC = [[CityListVC alloc]init];
        [cityListVC setDelegate:self];
    }
    [self.navigationController pushViewController:cityListVC animated:YES];
}

- (void) selectCity:(NSString*)cityId cityName:(NSString*)cityName
{
    if (cityName != nil) 
    {
        btnCity.title = cityName;
        gcityId = cityId;
        gcityName = cityName;
    }
    cityListVC = nil;
}
@end
