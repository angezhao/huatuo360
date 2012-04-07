//
//  DropDownList.m
//  huatuo360
//
//  Created by Alpha Wong on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DropDownList.h"

@interface DropDownList ()

@end

@implementation DropDownList
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        resultList = [NSMutableArray arrayWithCapacity:0];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"disease"
                                                         ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:path];
        srcList = [dict objectForKey:@"disease"];
    }
    return self;
}

- (void)setParent:(UIView*)container
{
    parent = container;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(30, 80, 220, 0)];
//    [self.view setFrame:CGRectMake(30, 36, 200, 0)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [resultList count];
}

- (GLfloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    // Configure the cell...
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [resultList objectAtIndex:row];
    
    return cell;
}

- (void)setHidden:(BOOL)hidden 
{
    if(!hidden) 
        [parent addSubview:self.view];
    
	NSInteger height = hidden ? 0 : 30 * MIN(5, [resultList count]);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3f];
    [self.view setFrame:CGRectMake(30, 33, 220, height)];
	[UIView commitAnimations];
    
    if(hidden)
        [self.view removeFromSuperview];
}

- (void)update:(NSString*)filter
{
    [resultList removeAllObjects];
    NSLog(@"%i", [resultList count]);
    for (NSString* content in srcList) 
    {
        if (NSNotFound != [content rangeOfString:filter options:NSLiteralSearch].location) 
        {
            [resultList addObject:content];
        }
    }
    NSLog(@"%i", [resultList count]);
    if([resultList count] > 0)
    {
        [self.tableView reloadData];
        [self setHidden:NO];
    }
    else 
    {
        [self setHidden:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FALSE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    delegate.text = [resultList objectAtIndex:[indexPath row]];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self setHidden:YES];
}

@end
