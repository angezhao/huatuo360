//
//  ListViewController1.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListViewController1.h"
#import "Constants.h"

@interface ListViewController1 ()

@end

@implementation ListViewController1
@synthesize listView;
@synthesize tableTitle;
@synthesize params;
- (id)init
{
    self = [super initWithNibName:@"ListViewController1" bundle:nil];
    if (self) {
        listData = nil;//[NSMutableArray arrayWithCapacity:0];
        page = 1;
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
        if (total == 0 || row == 0) //预防数据有问题
            cell.textLabel.text = @"没有数据";
        else
            cell.textLabel.text = [[NSString alloc]initWithFormat:@"显示下%i条", perpage];
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
    titleLabel.text = [self getTitleByIndex:row];
    introLabel.text = [self getIntroByIndex:row];    
    return cell;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int row = [indexPath row];
    if(total == 0)
        return nil;
    return indexPath;
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
@end
