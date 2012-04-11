//
//  HospitalDetailVC.m
//  huatuo360
//
//  Created by Zhao Ange on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HospitalDetailVC.h"
#import "CommentListViewController.h"
#import "CommentViewController.h"
#import "LoginViewController.h"
#import "Constants.h"

@interface HospitalDetailVC ()

@end

@implementation HospitalDetailVC
@synthesize detailView;

- (id)initWithHospId:(NSString*)hid hname:(NSString*)hname
{
    self = [super initWithNibName:@"DoctorDetailVC" bundle:nil];
    if (self) {
        // Custom initialization           
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
        hospitalId = hid;
        hospitalName = hname;
        labels = [[NSArray alloc]initWithObjects:@"医院等级：", @"联系地址：", @"联系电话：", nil];
        infoKeys = [[NSArray alloc]initWithObjects:@"level", @"address", @"tel", nil];
        //评论按钮
        btnComment  = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UITabBarSystemItemContacts target:self action:@selector(showCommentView)];
        [self.navigationItem setRightBarButtonItem:btnComment];
        
        needRequest = TRUE;        
    }
    return self;
}

- (void)showCommentView
{
    if(isLogin){//判断是否已经登陆
        NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
        [tmp setObject:hospitalName forKey:@"_name"];
        [tmp setObject:hospitalId forKey:@"hospid"];
        CommentViewController* cvc = [[CommentViewController alloc]init];
        cvc.params = tmp;
    [self.navigationController pushViewController:cvc animated:TRUE];
    }else{
        LoginViewController* lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        //加参数登陆成功后返回评论页
        [self.tabBarController setSelectedIndex:2];
    }

}

- (void)loadData:(NSDictionary *)data
{
    hospitalData = data;
    [detailView reloadData];
    btnComment.enabled = TRUE;
}

- (void) requestFailed:(NSError*)error
{
    btnComment.enabled = TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(needRequest)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
        [params setObject:_hospital forKey:@"interfaceName"];
        [params setObject:hospitalId forKey:@"id"];
        manager = [AsiObjectManager alloc];
        [manager setDelegate:self];
        [manager requestData:params];
        needRequest = FALSE;
    }
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
            title = hospitalName;
            break;
            
        case 1:
            title = @"医院科室";
            break;
            
        case 2:
            title = @"医院介绍";
            break;
        case 3:
            title = @"特色专科";
            break;
    }
    
    return title;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //评论条数大于0时评论栏可以选择
    int section = [indexPath section];
    int row = [indexPath row];
    if(section == 0 && row == 3 
       && [[hospitalData objectForKey:@"comment"] intValue] > 0 )
    {
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    int section = [indexPath section];
    int row = [indexPath row];
    if(section == 0 && row == 3)
    {
        //查看评论
        NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
        [tmp setObject:hospitalId forKey:@"hospid"];
        CommentListViewController* clvc = [[CommentListViewController alloc]init];
        clvc.params = tmp;
        clvc.tableTitle = [[NSString alloc]initWithFormat:@"%@医院", hospitalName];
        infoViewToShow = clvc;
        [self.navigationController pushViewController:clvc animated:true];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([hospitalData objectForKey:@"specialty"])
        return 4;
    else 
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil == hospitalData)
        return 0;
    
    int count;
    switch (section) 
    {
        case 0:
            count = 4;
            break;
            
        case 1:
            count = 1;
            break;
            
        case 2:
            count = 1;
            break;
            
        case 3:
            count = 1;
            break;
    }
    return count;
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
        case 1:
            cell = [self introCellForSection:section];
            break;
        case 2:
            cell = [self introCellForSection:section];
            break;
        case 3:
            cell = [self introCellForSection:section];
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 44;
    int row = [indexPath row];
    if(hospitalData == nil || row == 3)
        return height;
    switch ([indexPath section]) 
    {
        case 0://信息contentText];
            //处理联系电话
            {
                if(row == 2)
                    height = [self cellHeightForText:[[hospitalData objectForKey:[infoKeys objectAtIndex:row]] stringByReplacingOccurrencesOfString:@"," withString:@"\n"]
                                              margin:0 
                                               width:CELL_RIGHT_CONTENT_WIDTH 
                                                          fontsize:INFO_FONT_SIZE];
                else
                    height = [self cellHeightForText:[hospitalData objectForKey:[infoKeys objectAtIndex:row]]
                                          margin:0 
                                           width:CELL_RIGHT_CONTENT_WIDTH 
                                        fontsize:INFO_FONT_SIZE];
            }
            break;
            
        case 1://医院科室
            {
                NSArray *myArray = [hospitalData objectForKey:@"departments"];
                NSString* departments = nil;
                for (NSString *department in myArray) {
                    if(departments == nil)
                        departments = department;
                    else
                        departments = [NSString stringWithFormat:@"%@ %@", departments, department]; 
                }
                height = [self cellHeightForText:departments
                                          margin:12 
                                           width:CELL_CONTENT_WIDTH 
                                        fontsize:INTRO_FONT_SIZE];
            }
            break;
             
        case 2://医院介绍
            height = [self cellHeightForText:[hospitalData objectForKey:@"info"]
                                      margin:12 
                                       width:CELL_CONTENT_WIDTH 
                                    fontsize:INTRO_FONT_SIZE];
            break;
        
        case 3://特色专科
            height = [self cellHeightForText:[hospitalData objectForKey:@"specialty"]
                                        margin:12 
                                        width:CELL_CONTENT_WIDTH 
                                    fontsize:INTRO_FONT_SIZE];
            break;
    }
    return height;
}

- (UITableViewCell *)infoCellForRow:(int)row
{
    UITableViewCell *cell;
    
    if(row == 3)
    {
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        
        cell = [detailView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: SimpleTableIdentifier];
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize:INFO_FONT_SIZE];
            int count = [[hospitalData objectForKey:@"comment"] intValue];
            cell.textLabel.text = [[NSString alloc]initWithFormat:@"评论(%i条)", count];
            if(count > 0)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else 
    {
        UILabel *titleLabel;
        UILabel *contentLabel;
        static NSString *InfoIdentifier = @"InfoIdentifier";
        cell = [detailView dequeueReusableCellWithIdentifier:InfoIdentifier];
        UIFont* textfont = [UIFont systemFontOfSize:INFO_FONT_SIZE];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: InfoIdentifier];
            
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 90, 25)]; 
            titleLabel.tag = 99;   
            titleLabel.font = [UIFont boldSystemFontOfSize:INFO_FONT_SIZE];
            titleLabel.textAlignment = UITextAlignmentRight;
            titleLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:titleLabel];
            
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, 210, 1000)];
            //            contentLabel = cell.textLabel;
            
            contentLabel.tag = 100;
            contentLabel.font = textfont;
            contentLabel.textAlignment = UITextAlignmentLeft;
            contentLabel.backgroundColor = [UIColor clearColor];
            [contentLabel setLineBreakMode:UILineBreakModeWordWrap];
            [contentLabel setMinimumFontSize:INTRO_FONT_SIZE];
            [contentLabel setNumberOfLines:0];
            [cell.contentView addSubview:contentLabel];        
        }
        else 
        {
            contentLabel = (UILabel*)[cell viewWithTag:99];
            contentLabel = (UILabel*)[cell viewWithTag:100];
        }  
        
        NSString* contentText = nil;
        if(row == 2)
            contentText = [[hospitalData objectForKey:[infoKeys objectAtIndex:row]] stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        else
            contentText = [hospitalData objectForKey:[infoKeys objectAtIndex:row]];   
                              
        CGSize constraint = CGSizeMake(CELL_RIGHT_CONTENT_WIDTH, 20000.0f);        
        CGSize size = [contentText sizeWithFont:textfont constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        [contentLabel setFrame:CGRectMake(85, 1, 210, MAX(size.height, 44.0f))];
        titleLabel.text = [labels objectAtIndex:row];
        contentLabel.text = contentText;
        //        NSLog(@"fff%@", contentLabel.text);
    }
    return cell;
}

- (UITableViewCell *)introCellForSection:(int)section
{
    static NSString *IntroIdentifier = @"IntroIdentifier";    
    UILabel* label;
    UITableViewCell *cell = [detailView dequeueReusableCellWithIdentifier:IntroIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: IntroIdentifier];
        label = cell.textLabel;
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:INTRO_FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:INTRO_FONT_SIZE]];
        //        [label setTag:1];
    }
    
    NSString *text = nil;
    switch (section) {
        case 1:
            {
                NSArray *myArray = [hospitalData objectForKey:@"departments"];
                NSString* departments = nil;
                for (NSString *department in myArray) {
                    if(departments == nil)
                        departments = department;
                    else
                        departments = [NSString stringWithFormat:@"%@ %@", departments, department]; 
                }
                text = departments;
            }
            break;
        case 2:
            text = [hospitalData objectForKey:@"info"];
            break;
        case 3:
            text = [hospitalData objectForKey:@"specialty"];
            break;
    }

    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:INTRO_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    //    if (!label)
    //        label = (UILabel*)[cell viewWithTag:1];
    label = cell.textLabel;
    
    [label setText:text];
    [label setFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, MAX(size.height, 44.0f))];
    return cell;
}

- (float)cellHeightForText:(NSString*)text margin:(float)margin width:(float)width fontsize:(int)fontsize
{    
    CGSize constraint = CGSizeMake(width - (margin * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontsize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (margin * 2);
}

@end
