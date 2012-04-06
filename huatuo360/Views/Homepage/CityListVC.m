//
//  CityListVC.m
//  huatuo360
//
//  Created by Alpha Wong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CityListVC.h"
@interface CityListVC ()

@end

@implementation CityListVC
@synthesize table, search;

- (id)init
{
    self = [super initWithNibName:@"CityListVC" bundle:nil];
    if (self) {
        self.title = @"选择城市";
        // Custom initialization
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
        data = [[NSDictionary alloc] initWithContentsOfFile:path];
        //字母排序
        keys = [[data allKeys]sortedArrayUsingSelector:@selector(compare:)];
        
        searchResultList = [NSMutableArray arrayWithCapacity:0];
        cityName2Id = [NSMutableDictionary dictionaryWithCapacity:550];
        for (NSString* key in data) 
        {
            NSArray *cityItems = [data objectForKey:key];
            for (NSString *dataString in cityItems) 
            {
                NSArray* tmp = [dataString componentsSeparatedByString:@":"];
                [cityName2Id setObject:[tmp objectAtIndex:0] forKey:[tmp objectAtIndex:1]];
            }
        }
        
        isSearching = FALSE;
        self.hidesBottomBarWhenPushed = YES;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return isSearching ? 1 : [keys count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return isSearching ? nil : keys;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching)
        return [searchResultList count];
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [data objectForKey:key];
    return [nameSection count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (isSearching)
        return nil;
    
    NSString *key = [keys objectAtIndex:section];
    if([key isEqualToString:@"#"])
        return @"热门城市";
    
    return key;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//- (NSIndexPath *)tableView:(UITableView *)tableView 
//  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [search resignFirstResponder];
//    search.text = @"";
//    isSearching = FALSE;
//    [tableView reloadData];
//    return indexPath;
//}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index
{
    NSString *key = [keys objectAtIndex:index];
    if (key == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else 
        return index;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier ];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier: SectionsTableIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    cell.textLabel.text = [self getNameForSection:section row:row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    int section = [indexPath section];
    int row = [indexPath row];    
    NSString* cityName = [self getNameForSection:section row:row];
    NSString* cityId = [cityName2Id objectForKey:cityName];
    [delegate selectCity:cityId cityName:cityName];
    [self.navigationController popViewControllerAnimated:TRUE];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSString*)getNameForSection:(int)section row:(int)row
{
    if(isSearching)
        return [searchResultList objectAtIndex:row];
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSections = [data objectForKey:key];
    return [self getNameFromDataString:[nameSections objectAtIndex:row]];
}

- (NSString*)getNameFromDataString:(NSString*)string
{
    NSArray *tmp = [string componentsSeparatedByString:@":"];
    return [tmp objectAtIndex:1];
}

- (NSString*)getIdFromDataString:(NSString*)string
{
    NSArray *tmp = [string componentsSeparatedByString:@":"];
    return [tmp objectAtIndex:0];
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    NSString *searchTerm = [searchBar text];
    [searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:true];
//    if ([searchBar.text length] > 0)
//    {
//        isSearching = TRUE;
//        [searchResultList removeAllObjects];
//        for (NSString *cityName in cityName2Id) 
//        {
//            if (NSNotFound != [cityName rangeOfString:searchTerm options:NSLiteralSearch].location) 
//            {
//                [searchResultList addObject:cityName];
//            }
//        }
//    }
//    else 
//    {
//        isSearching = FALSE;
////        [searchBar setShowsCancelButton:YES animated:true];
//    }
//    [table reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = TRUE;
    [table reloadData];
	[searchBar setShowsCancelButton:YES animated:true];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm
{
    [searchResultList removeAllObjects];
    if ([searchTerm length] == 0)
    {
        isSearching = FALSE;
        [table reloadData];
        return;
    }
    
    isSearching = TRUE;
    for (NSString *cityName in cityName2Id) 
    {
        if (NSNotFound != [cityName rangeOfString:searchTerm options:NSLiteralSearch].location) 
        {
            [searchResultList addObject:cityName];
        }
    }
    [table reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = FALSE;
    search.text = @"";
    [searchResultList removeAllObjects];
    [table reloadData];
    
	[searchBar setShowsCancelButton:NO animated:true];
    [searchBar resignFirstResponder];
}

- (void) setDelegate:(id)del
{
    delegate = del;
}

//- (IBAction)returnToHomepage:(id)sender
//{
//    [delegate selectCity:nil cityName:nil];
//    [self.navigationController popViewControllerAnimated:TRUE];
//}
@end
