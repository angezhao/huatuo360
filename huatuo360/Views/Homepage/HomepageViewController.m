//
//  HomepageViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomepageViewController.h"

@implementation HomepageViewController
@synthesize listData;
//@synthesize searchBar;
@synthesize searchBarHolders;
const static int ILLNESS = 0;
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
    [self.tabBarController setSelectedIndex:3];
	[searchBar setShowsCancelButton:NO animated:true];
    [searchBar resignFirstResponder];
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
    [self.tabBarController setSelectedIndex:1];
}
@end
