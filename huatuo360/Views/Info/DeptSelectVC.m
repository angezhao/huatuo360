//
//  DeptSelectVC.m
//  huatuo360
//
//  Created by Alpha Wong on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeptSelectVC.h"
#import "Constants.h"

@interface DeptSelectVC ()

@end

@implementation DeptSelectVC

- (id)init
{
    self = [super initWithNibName:@"DeptSelectVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.title = @"华佗360";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    return @"科室选择";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [departments count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    int row = [indexPath row];
    [delegate selectDept:[[departments objectAtIndex:row] objectForKey:@"id"] deptName:[[departments objectAtIndex:row] objectForKey:@"name"]];
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
    }
    cell.textLabel.text = [[departments objectAtIndex:row] objectForKey:@"name"]; 
    
    return cell;    
}

- (void) setDelegate:(id)del
{
    delegate = del;
}
@end
