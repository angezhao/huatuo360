//
//  ListViewController2.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListViewController2.h"
#import "Constants.h"

@interface ListViewController2 ()

@end

@implementation ListViewController2
@synthesize listView;
@synthesize tableTitle;
@synthesize params;
- (id)init
{
    self = [super initWithNibName:@"ListViewController2" bundle:nil];
    if (self) {
        listData = nil;
        page = 1;
        //默认显示下级菜单
        displayerNext = true;
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
    if(nil == listData)
        return 0;
    
    int showCount = [listData count];
    if(showCount < total || total == 0)
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
        if (total == 0 || row == 0) //预防数据有问题
            cell.textLabel.text = @"没有数据";
        else
            cell.textLabel.text = [[NSString alloc]initWithFormat:@"显示下%i条", perpage];
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
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        if(displayerNext)
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
