//
//  ListViewController1.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListViewController1.h"

@interface ListViewController1 ()

@end

@implementation ListViewController1
@synthesize listView;
@synthesize tableTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        listData = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //    [self 
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ListTableIdentifier = @"ListTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             ListTableIdentifier];
    NSUInteger row = [indexPath row];
    UILabel *titleLabel;
    UILabel *introLabel;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: ListTableIdentifier];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 270, 25)]; 
        titleLabel.tag = 99;   
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleLabel];
        
        introLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 270, 25)];
        introLabel.tag = 100;
        introLabel.font = [UIFont boldSystemFontOfSize:12];
        introLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:introLabel];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        titleLabel = (UILabel*)[cell viewWithTag:99];
        introLabel = (UILabel*)[cell viewWithTag:100];
    }
    titleLabel.text = [self getTitleByIndex:row];
    introLabel.text = [self getIntroByIndex:row];    
    return cell;
    
}

- (NSString*)getTitleByIndex:(int)index
{
    @throw [NSException exceptionWithName:@"panic"
                                   reason:@"this method must be override"
                                 userInfo:nil];
    return @"";
}

- (NSString*)getIntroByIndex:(int)index
{
    @throw [NSException exceptionWithName:@"panic"
                                   reason:@"this method must be override"
                                 userInfo:nil];
    return @"";
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DoctorListViewController* doctorListVC = [[DoctorListViewController alloc] initWithNibName:@"ListView" bundle:nil];
//    [self.navigationController pushViewController:doctorListVC animated:true];
//    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
//}


@end
