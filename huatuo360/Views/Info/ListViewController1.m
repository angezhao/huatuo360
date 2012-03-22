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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: ListTableIdentifier];
    }    
    
    NSUInteger row = [indexPath row];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 270, 25)];    
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [listData objectAtIndex:row];
    [cell.contentView addSubview:nameLabel];
    
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 270, 25)];
    introLabel.font = [UIFont boldSystemFontOfSize:12];
    introLabel.backgroundColor = [UIColor clearColor];
    introLabel.text = @"很长的介绍很长的介绍很长的介绍很长的介绍很长的介绍很长的介绍";
    [cell.contentView addSubview:introLabel];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DoctorListViewController* doctorListVC = [[DoctorListViewController alloc] initWithNibName:@"ListView" bundle:nil];
//    [self.navigationController pushViewController:doctorListVC animated:true];
//    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
//}


@end
