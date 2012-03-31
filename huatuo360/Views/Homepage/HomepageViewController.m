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
#import "DoctorListViewController.h"
#import "Constants.h"

@implementation HomepageViewController
//@synthesize searchBar;
//@synthesize searchBarHolders;
const static int DISEASE = 0;
const static int HOSPITAL = 1;
const static int DOCTOR = 2;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Homepage", @"Homepage");
        self.tabBarItem.image = [UIImage imageNamed:@"homepage"];
        
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:true];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope 
{
    searchType = selectedScope;
    searchBar.placeholder = [searchBarHolders objectAtIndex:searchType];
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
                [params setObject:_diseaseList forKey:@"interfaceName"];
                [params setObject:@"1" forKey:@"page"];
                [params setObject:searchBar.text forKey:@"disease"];
                DiseaseListViewController* dlvc = [[DiseaseListViewController alloc]initWithNibName:@"ListView" bundle:nil];
                dlvc.params = params;
                dlvc.tableTitle = [[NSString alloc]initWithFormat:@"搜索\"%@\"的导医结果", searchBar.text];                
                infoViewToShow = dlvc;
                [self.tabBarController setSelectedIndex:1];
            }
            
            break;
        case HOSPITAL:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:_hospitalList forKey:@"interfaceName"];
                [params setObject:@"1" forKey:@"page"];
                [params setObject:searchBar.text forKey:@"hospital"];
                HospitalListViewController* hlvc = [[HospitalListViewController alloc]initWithNibName:@"ListView" bundle:nil];
                hlvc.params = params;
                hlvc.tableTitle = [[NSString alloc]initWithFormat:@"搜索\"%@\"的医院结果", searchBar.text];                
                infoViewToShow = hlvc;
                [self.tabBarController setSelectedIndex:1];
            }
            
            break;
        case DOCTOR:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:_doctorList forKey:@"interfaceName"];
                [params setObject:@"1" forKey:@"page"];
                [params setObject:searchBar.text forKey:@"doctor"];
                DoctorListViewController* dlvc = [[DoctorListViewController alloc]initWithNibName:@"ListView" bundle:nil];
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

-(IBAction)switchSearchTab:(id)sender
{
    searchType = [sender selectedSegmentIndex];
    [sender setPlaceholder:[searchBarHolders objectAtIndex:searchType]];
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
//    [searchBar resignFirstResponder];
    switch ([indexPath row]) 
    {
        case 0:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:_hospitalList forKey:@"interfaceName"];
                [params setObject:@"1" forKey:@"page"];
                HospitalListViewController* hlvc = [[HospitalListViewController alloc]initWithNibName:@"ListView" bundle:nil];
                hlvc.params = params;
                hlvc.tableTitle = @"医院排行";
                infoViewToShow = hlvc;
                [self.tabBarController setSelectedIndex:1];
            }  
            break;
        case 1:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:_departmentList forKey:@"interfaceName"];
                [params setObject:@"1" forKey:@"page"];
                [params setObject:@"1" forKey:@"_hospital"];
                DepartmentListViewController* dlvc = [[DepartmentListViewController alloc]initWithNibName:@"ListView" bundle:nil];
                dlvc.params = params;
                dlvc.tableTitle = @"科室排行";
                infoViewToShow = dlvc;
                [self.tabBarController setSelectedIndex:1];
            }  
            break;
        case 2:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:_departmentList forKey:@"interfaceName"];
                [params setObject:@"1" forKey:@"page"];
                [params setObject:@"1" forKey:@"_doctor"];
                DepartmentListViewController* dlvc = [[DepartmentListViewController alloc]initWithNibName:@"ListView" bundle:nil];
                dlvc.params = params;
                dlvc.tableTitle = @"科室排行";
                infoViewToShow = dlvc;
                [self.tabBarController setSelectedIndex:1];
            }  
            break;
        case 3:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:_diseaseList forKey:@"interfaceName"];
                [params setObject:@"1" forKey:@"page"];
                [params setObject:@"1" forKey:@"_hospital"];
                DiseaseListViewController* dlvc = [[DiseaseListViewController alloc]initWithNibName:@"ListView" bundle:nil];
                dlvc.params = params;
                dlvc.tableTitle = @"常见疾病";
                infoViewToShow = dlvc;
                [self.tabBarController setSelectedIndex:1];
            }  
            break;
        case 4:
            {
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
                [params setObject:_diseaseList forKey:@"interfaceName"];
                [params setObject:@"1" forKey:@"page"];
                [params setObject:@"1" forKey:@"_doctor"];
                DiseaseListViewController* dlvc = [[DiseaseListViewController alloc]initWithNibName:@"ListView" bundle:nil];
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
}
@end
