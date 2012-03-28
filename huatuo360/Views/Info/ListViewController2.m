//
//  ListViewController2.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListViewController2.h"

@interface ListViewController2 ()

@end

@implementation ListViewController2
@synthesize listView;
@synthesize tableTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        listData = [NSMutableArray arrayWithCapacity:0];
        page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    int showCount = [listData count];
    if(showCount < total)
        return showCount + 1;
    else 
        return showCount;
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
        cell.textLabel.text = @"显示下10条";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self getTitleByIndex:row]; 
    
    return cell;    
}

- (NSString*)getTitleByIndex:(int)index
{
    @throw [NSException exceptionWithName:@"panic"
                                   reason:@"this method must be override"
                                 userInfo:nil];
    return @"";
}

@end
