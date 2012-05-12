//
//  CommentDetailVC.m
//  huatuo360
//
//  Created by Zhao Ange on 12-5-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentDetailVC.h"
#import "Constants.h"

@interface CommentDetailVC ()

@end

@implementation CommentDetailVC
@synthesize detailView;
@synthesize params;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
        needRequest = TRUE;
    }
    return self;
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
        [params setObject:_commentDetail forKey:@"interfaceName"];
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

- (void)loadData:(NSDictionary *)data
{
    commentData = data;
    [detailView reloadData];
}

- (void) requestFailed:(NSError*)error
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil == commentData)
        return 0;

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    int row = [indexPath row];
    if(row == 0)
    {
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        cell = [detailView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: SimpleTableIdentifier];
            
        }
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 25)];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        nameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:nameLabel];
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 25)];
        dateLabel.textAlignment = UITextAlignmentRight;
        dateLabel.font = [UIFont boldSystemFontOfSize:16];
        dateLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:dateLabel];

        nameLabel.text = [commentData objectForKey:@"username"];
        dateLabel.text = [commentData objectForKey:@"time"];
    }
    else if(row == 1)
    {
        static NSString *DetailIdentifier = @"DetailIdentifier";    
        UILabel* label;
        cell = [detailView dequeueReusableCellWithIdentifier:DetailIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:DetailIdentifier];
            label = cell.textLabel;
            [label setLineBreakMode:UILineBreakModeWordWrap];
            [label setMinimumFontSize:INTRO_FONT_SIZE];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:INTRO_FONT_SIZE]];
        }
        
        NSString *text = [commentData objectForKey:@"message"];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:INTRO_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

        label = cell.textLabel;
        
        [label setText:text];
        [label setFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, MAX(size.height, 44.0f))];
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 44;
    int row = [indexPath row];
    if(row == 1)
    {
        NSString *text = [commentData objectForKey:@"message"];
        height = [self cellHeightForText:text
                                  margin:12 
                                   width:CELL_CONTENT_WIDTH 
                                fontsize:INTRO_FONT_SIZE];
    }
    return height;
}

- (float)cellHeightForText:(NSString*)text margin:(float)margin width:(float)width fontsize:(int)fontsize
{    
    CGSize constraint = CGSizeMake(width - (margin * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontsize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (margin * 2);
}


@end
