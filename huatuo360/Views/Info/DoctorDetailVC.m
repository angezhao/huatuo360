//
//  DoctorDetailVC.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DoctorDetailVC.h"
#import "Constants.h"

@interface DoctorDetailVC ()

@end

@implementation DoctorDetailVC
@synthesize detailView;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        labels = [[NSArray alloc]initWithObjects:@"职称：", @"擅长疾病：", @"所属科室：", @"所属医院：", nil];
//        NSLog(@"%@", labels);
//    }
//    return self;
//}

- (id)initWithDoctorId:(NSString*)did dname:(NSString*)dname
{
    self = [super initWithNibName:@"DoctorDetailVC" bundle:nil];
    if (self) {
        // Custom initialization
        doctorId = did;
        doctorName = dname;
        labels = [[NSArray alloc]initWithObjects:@"职称：", @"擅长疾病：", @"所属科室：", @"所属医院：", nil];
    }
    return self;
}

- (void)loadData:(NSDictionary *)data
{
    doctorData = data;
//    [detailView reloadSections:<#(NSIndexSet *)#> withRowAnimation:<#(UITableViewRowAnimation)#>];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:_doctor forKey:@"interfaceName"];
    [params setObject:doctorId forKey:@"id"];
    [[AsiObjectManager sharedManager] setDelegate:self];
    [[AsiObjectManager sharedManager] requestData:params];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title;
    switch(section)
    {
    case 0:
        title = doctorName;
        break;
        
    case 1:
        title = @"医生介绍";
        break;
        
    case 2:
        title = @"发表论文";
        break;
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
//    int row = [indexPath row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 5;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    int row = [indexPath row];
    int section = [indexPath section];
    switch (section) {
        case 0:
            cell = [self infoCellForRow:row];
            break;
            
        default:
            cell = [self infoCellForRow:4];
            break;
    }
    return cell;
}

- (UITableViewCell *)infoCellForRow:(int)row
{
    UITableViewCell *cell;
    
    if(row == 4)
    {
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        
        cell = [detailView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: SimpleTableIdentifier];
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            NSString* countText = [doctorData objectForKey:@"comment"];
            cell.textLabel.text = [[NSString alloc]initWithFormat:@"评论(%@条)", countText];
            if([countText intValue] > 0)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else 
    {
        UILabel *label;
        UILabel *text;
        static NSString *InfoIdentifier = @"InfoIdentifier";
        cell = [detailView dequeueReusableCellWithIdentifier:InfoIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: InfoIdentifier];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 25)]; 
            label.tag = 99;   
            label.font = [UIFont boldSystemFontOfSize:16];
            label.textAlignment = UITextAlignmentRight;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            
            text = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 25)];
            text.tag = 100;
            text.font = [UIFont boldSystemFontOfSize:16];
            text.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:text];
        }
        else {
            label = (UILabel*)[cell viewWithTag:99];
            text = (UILabel*)[cell viewWithTag:100];
        }
        label.text = [labels objectAtIndex:row];
        NSLog(@"%@", label.text);
        text.text = @"txt";//[texts objectAtIndex:row];
    }
    return cell;
}

- (UITableViewCell *)introCellForRow:(int)row
{
    UITableViewCell* cell = nil;
    return cell;
}

- (UITableViewCell *)thesisCellForRow:(int)row
{
    UITableViewCell* cell = nil;
    return cell;
}
@end
