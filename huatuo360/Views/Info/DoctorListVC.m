//
//  DoctorListVC.m
//  huatuo360
//
//  Created by Alpha Wong on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DoctorListVC.h"
#import "HospitalDetailVC.h"
#import "DoctorDetailVC.h"
#import "Constants.h"
#import "DeptSelectVC.h"

@interface DoctorListVC ()

@end

@implementation DoctorListVC
@synthesize params;
@synthesize listView, lbTitle, btnDept;
@synthesize tableTitle;
@synthesize hospitalName, departmentName, diseaseName;

- (id)init
{
    self = [super initWithNibName:@"DoctorListVC" bundle:nil];
    if (self) {
        // Custom initialization test
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
        firstAppear = true;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(firstAppear)
    {
        firstAppear = false;
        [params setObject:_doctorList forKey:@"interfaceName"];
        [params setObject:@"1" forKey:@"page"];
        manager = [AsiObjectManager alloc];
        if(departmentId != nil)
            [params setObject:departmentId forKey:@"deptid"];
        [manager setDelegate:self];
        [manager requestData:params];
        NSLog(@"params=%@",params); 
        if([params objectForKey:@"hospid"]){//从医院列表过来的医生列表
            //医院详情按钮
            btnDetail  = [[UIBarButtonItem alloc] initWithTitle:@"医院详情" style:UITabBarSystemItemContacts target:self action:@selector(showCommentView)];
            [self.navigationItem setRightBarButtonItem:btnDetail];
        }
        [btnDetail setEnabled:FALSE];
        lbTitle.text = self.tableTitle;
    }
}

- (void)showCommentView
{
    //NSLog(@"医院详情");
    NSString* hospitalId = [params objectForKey:@"hospid"];
//    NSString* hospitalName = [params objectForKey:@"_name"];
    HospitalDetailVC* hdvc = [[HospitalDetailVC alloc]initWithHospId:hospitalId hname:hospitalName];
    [self.navigationController pushViewController:hdvc animated:true];; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [lbTitle setLineBreakMode:UILineBreakModeWordWrap];
//    [label setMinimumFontSize:INTRO_FONT_SIZE];
    [lbTitle setNumberOfLines:0];
}

- (void)loadData:(NSDictionary *)data
{
    total = [[data objectForKey:@"total"]integerValue];
    if(nil == listData)
        listData = [[NSMutableArray alloc]initWithCapacity:0];
    [listData addObjectsFromArray:[data objectForKey:@"data"]];
    [self.listView reloadData]; 
    [btnDetail setEnabled:TRUE];
    
    if(hospitalName != nil && diseaseName != nil && departmentName != nil)
        self.tableTitle = [NSString stringWithFormat:@"%@ %@ 治疗\"%@\"的医生", hospitalName, departmentName, diseaseName];
    else if(hospitalName != nil && diseaseName != nil)
        self.tableTitle = [NSString stringWithFormat:@"%@ 治疗\"%@\"的医生", hospitalName, diseaseName];
    else if(hospitalName != nil && departmentName != nil)
        self.tableTitle = [NSString stringWithFormat:@"%@ %@ 的医生", hospitalName, departmentName];
    [self updateControlLocationForTitle:self.tableTitle];
    
    
}

- (void) updateControlLocationForTitle:(NSString*)title
{
    //标题
    CGRect lbRect = lbTitle.frame;
    CGSize constraint = CGSizeMake(lbRect.size.width, 20000.0f);
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat fYIncrement = size.height - lbRect.size.height;
    [lbTitle setText:title];
    lbRect.size.height += fYIncrement;
    [lbTitle setFrame:lbRect];
    
    NSLog(@"%f", fYIncrement);
    //科室按钮
    CGRect btnRect = btnDept.frame;
    btnRect.origin.y += fYIncrement;
    [btnDept setFrame:btnRect];
    //tableview
    CGRect tvRect = listView.frame;
    tvRect.origin.y += fYIncrement;
    tvRect.size.height -= fYIncrement;
    [listView setFrame:tvRect];
}

- (void) requestFailed:(NSError*)error
{
    [btnDetail setEnabled:TRUE];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    int row = [indexPath row];
    if (row == [listData count]) {
        [self nextPage];
        return;
    }
    
    NSMutableDictionary *itemData = [listData objectAtIndex:row];
    //    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
    //    [tmp setObject:_doctor forKey:@"interfaceName"];
    //    [tmp setObject:@"1" forKey:@"page"];
    //    [tmp setObject:[itemData objectForKey:@"id"] forKey:@"id"];
    
    NSString* doctorId = [itemData objectForKey:@"id"];
    NSString* doctorName = [itemData objectForKey:@"name"];
    
    DoctorDetailVC* ddvc = [[DoctorDetailVC alloc]initWithDoctorId:doctorId dname:doctorName];
    [self.navigationController pushViewController:ddvc animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}

- (void)nextPage
{
    NSString *pageText = [[NSString alloc]initWithFormat:@"%i", ++page];
    [params setObject:pageText forKey:@"page"];
    [manager requestData:params];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil == listData)
        return 0;
    
    int showCount = [listData count];
    if(showCount < total || total == 0)
        return showCount + 1;
    else 
        return showCount;
    
    //    return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    //下一页按钮
    if (row == [listData count]) 
    {
        static NSString *NextPageIdentifier = @"NextPageIdentifier";    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NextPageIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: NextPageIdentifier];
        }
        //        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 270, 25)];
        //        [btn setTitle:@"显示下10条" forState:UIControlStateNormal];
        //        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        btn.backgroundColor = [UIColor clearColor];
        //        [cell.contentView addSubview:btn];
        if (total == 0) 
            cell.textLabel.text = @"没有数据";
        else
        {
            int countToShow = MIN(perpage, total - [listData count]);
            cell.textLabel.text = [[NSString alloc]initWithFormat:@"显示下%i条", countToShow];
        }
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
    
    UILabel *titleLabel;
    UILabel *introLabel;
    static NSString *ListTableIdentifier = @"ListTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             ListTableIdentifier];
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
        introLabel.font = [UIFont systemFontOfSize:14];
        introLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:introLabel];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        titleLabel = (UILabel*)[cell viewWithTag:99];
        introLabel = (UILabel*)[cell viewWithTag:100];
    }
    
    NSDictionary* itemData = [listData objectAtIndex:row];
    titleLabel.text = [itemData objectForKey:@"name"];
    introLabel.text = [itemData objectForKey:@"info"];    
    return cell;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int row = [indexPath row];
    if(total == 0)
        return nil;
    return indexPath;
}

- (void) selectDept:(NSString*)deptId deptName:(NSString*)deptName
{
    departmentId = deptId;
    departmentName = deptName;
    [btnDept setTitle:deptName forState:UIControlStateNormal];
    listData = nil;
    firstAppear = true;
}

- (IBAction)showDeptList:(id)sender
{
    if(departments == nil)
    {
        NSMutableDictionary* deptParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [deptParams setObject:_departmentList forKey:@"interfaceName"];
        NSDictionary *data = [manager syncRequestData:deptParams];
        if(data != nil)
            departments = [data objectForKey:@"data"];
    }
    DeptSelectVC* dsvc = [[DeptSelectVC alloc]init];
    [dsvc setDelegate:self];
    [self.navigationController pushViewController:dsvc animated:TRUE];
}
@end
