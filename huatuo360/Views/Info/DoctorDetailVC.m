//
//  DoctorDetailVC.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DoctorDetailVC.h"
#import "CommentListViewController.h"
#import "Constants.h"
#import "CommentViewController.h"

@interface DoctorDetailVC ()

@end

@implementation DoctorDetailVC
@synthesize detailView;
#define INIT_SHOW_THESIS_COUNT 3

- (id)initWithDoctorId:(NSString*)did dname:(NSString*)dname
{
    self = [super initWithNibName:@"DoctorDetailVC" bundle:nil];
    if (self) {
        // Custom initialization           
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
        doctorId = did;
        doctorName = dname;
        labels = [[NSArray alloc]initWithObjects:@"职称：", @"擅长疾病：", @"所属科室：", @"所属医院：", nil];
        infoKeys = [[NSArray alloc]initWithObjects:@"title", @"goodDisease", @"department", @"hospital", nil];
        showAllThesis = FALSE;
        //评论按钮
        btnComment = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UITabBarSystemItemContacts target:self action:@selector(showCommentView)];
        [self.navigationItem setRightBarButtonItem:btnComment];
        needRequest = TRUE;
        showAllIntro = FALSE;
    }
    return self;
}

- (void)showCommentView
{
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
    [tmp setObject:doctorName forKey:@"_name"];
    [tmp setObject:doctorId forKey:@"doctorid"];
    CommentViewController* cvc = [[CommentViewController alloc]init];
    cvc.params = tmp;
    [self.navigationController pushViewController:cvc animated:TRUE];
}

- (void)loadData:(NSDictionary *)data
{
    doctorData = data;
    thesis = [doctorData objectForKey:@"thesis"];
    showAllThesis = [thesis count] <= INIT_SHOW_THESIS_COUNT;
    [detailView reloadData];
    btnComment.enabled = TRUE;
}

- (void)requestFailed:(NSError *)error
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
    if(needRequest || flashView)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
        [params setObject:_doctor forKey:@"interfaceName"];
        [params setObject:doctorId forKey:@"id"];
        manager = [AsiObjectManager alloc];
        [manager setDelegate:self];
        [manager requestData:params];
        needRequest = FALSE;
        flashView = false;
        //阻止数据为请求下来就点击评论按钮
        btnComment.enabled = FALSE;
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
            title = [[NSString alloc]initWithFormat:@"%@ 医生", doctorName];
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //评论条数大于0时评论栏可以选择
    int section = [indexPath section];
    int row = [indexPath row];
    if(section == 0 && row == 4 
       && [[doctorData objectForKey:@"comment"] intValue] > 0 )
    {
        return indexPath;
    }    
    else if(section == 1 && row == 1)
    {
        return indexPath;
    }
    //显示全部论文
    else if(section == 2 && !showAllThesis && row == INIT_SHOW_THESIS_COUNT)
    {
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    int section = [indexPath section];
    int row = [indexPath row];
    if(section == 0 && row == 4)
    {
        //查看评论
        NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
        [tmp setObject:doctorId forKey:@"doctorid"];
        CommentListViewController* clvc = [[CommentListViewController alloc]init];
        clvc.params = tmp;
        clvc.tableTitle = [[NSString alloc]initWithFormat:@"%@医生", doctorName];
        [self.navigationController pushViewController:clvc animated:true];
    }
    else if(section == 1 && row == 1)
    {
        showAllIntro = TRUE;
        [tableView reloadData];
    }
    else if(section == 2 && !showAllThesis && row == INIT_SHOW_THESIS_COUNT)
    {
        //显示所有论文
        showAllThesis = TRUE;
        [tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil == doctorData)
        return 0;
    
    int count;
    switch (section) 
    {
        case 0:
            count = 5;
            break;
            
        case 1:
            count = showAllIntro ? 1 : 2;
            break;
            
        case 2:
            if(nil == thesis)
                count = 0;
            else 
            {
                if(showAllThesis)
                    count = [thesis count];
                else 
                    count = INIT_SHOW_THESIS_COUNT + 1;
            }
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
            cell = [self introCellForRow:row];
            break;
        case 2:
            cell = [self thesisCellForRow:row];
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 44;
    int row = [indexPath row];
    if(doctorData == nil || row == 4)
        return height;
    switch ([indexPath section]) 
    {
        case 0://信息contentText];
            height = [self cellHeightForText:[doctorData objectForKey:[infoKeys objectAtIndex:row]]
                                      margin:0 
                                       width:CELL_RIGHT_CONTENT_WIDTH 
                                    fontsize:INFO_FONT_SIZE];
            break;
            
        case 1://介绍
            if(row == 0)
            {
                NSString *text = [doctorData objectForKey:@"info"];
                if(!showAllIntro)
                    text = [NSString stringWithFormat:@"%@...", [text substringToIndex:64]];
                height = [self cellHeightForText:text
                                        margin:12 
                                        width:CELL_CONTENT_WIDTH 
                                        fontsize:INTRO_FONT_SIZE];
            }
            else 
                height = 44;
            break;
            
        case 2://论文
            if(showAllThesis || row != (INIT_SHOW_THESIS_COUNT + 1))//不是显示全部
            {
                height = [self cellHeightForText:[thesis objectAtIndex:row]
                                    margin:0 
                                    width:CELL_CONTENT_WIDTH 
                                    fontsize:INTRO_FONT_SIZE];
            }
            break;
    }
    return height;
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
            cell.textLabel.font = [UIFont boldSystemFontOfSize:INFO_FONT_SIZE];
        }
        int count = [[doctorData objectForKey:@"comment"] intValue];
        cell.textLabel.text = [[NSString alloc]initWithFormat:@"评论(%i条)", count];
        if(count > 0)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        
        NSString* contentText = [doctorData objectForKey:[infoKeys objectAtIndex:row]];                        
        CGSize constraint = CGSizeMake(CELL_RIGHT_CONTENT_WIDTH, 20000.0f);        
        CGSize size = [contentText sizeWithFont:textfont constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        [contentLabel setFrame:CGRectMake(85, 1, 210, MAX(size.height, 44.0f))];
        titleLabel.text = [labels objectAtIndex:row];
        contentLabel.text = contentText;
//        NSLog(@"fff%@", contentLabel.text);
    }
    return cell;
}

- (UITableViewCell *)introCellForRow:(int)row
{
    UITableViewCell *cell;
    if(row == 0)
    {
        static NSString *IntroIdentifier = @"IntroIdentifier";    
        UILabel* label;
        cell = [detailView dequeueReusableCellWithIdentifier:IntroIdentifier];
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
        
        NSString *text = [doctorData objectForKey:@"info"];
        if(!showAllIntro)
            text = [NSString stringWithFormat:@"%@...", [text substringToIndex:64]];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:INTRO_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
    //    if (!label)
    //        label = (UILabel*)[cell viewWithTag:1];
        label = cell.textLabel;
        
        [label setText:text];
        [label setFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, MAX(size.height, 44.0f))];
    }
    else if(row == 1)
    {
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        cell = [detailView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: SimpleTableIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
        }
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        cell.textLabel.text = @"查看全部信息";
    }
    
    return cell;
}

- (float)cellHeightForText:(NSString*)text margin:(float)margin width:(float)width fontsize:(int)fontsize
{    
    CGSize constraint = CGSizeMake(width - (margin * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontsize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (margin * 2);
}

- (UITableViewCell *)thesisCellForRow:(int)row
{
    static NSString *ThesisIdentifier = @"ThesisIdentifier";    
    UILabel* label;
    UITableViewCell *cell = [detailView dequeueReusableCellWithIdentifier:ThesisIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: ThesisIdentifier];
        label = cell.textLabel;
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:INTRO_FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:INTRO_FONT_SIZE]];
        //        [label setTag:1];
    }
    label = cell.textLabel;
    NSLog(@"row%i", row);
    
    NSString *text;
    if(!showAllThesis && row == INIT_SHOW_THESIS_COUNT)
    {
        text = @"显示全部论文";
        label.textAlignment = UITextAlignmentCenter;
    }
    else 
    {
        text = [thesis objectAtIndex:row];
        label.textAlignment = UITextAlignmentLeft;
    }
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:INTRO_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    [label setText:text];
    [label setFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, MAX(size.height, 44.0f))];
    return cell;
}
@end
