//
//  DoctorListViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DoctorListViewController.h"
#import "Constants.h"


@implementation DoctorListViewController
extern NSString* const _departmentList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        listData = [[NSArray alloc]initWithObjects: 
                    @"医生1",
                    @"医生2",
                    @"医生3",
                    @"医生4",
                    @"医生5",
                    @"医生6",
                    @"医生7",
                    @"医生8",
                    @"医生9",
                    @"医生10",
                    @"医生11", nil];
        
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSMutableDictionary *urlParam = [NSMutableDictionary dictionaryWithCapacity:10];
    [urlParam setObject:_departmentList forKey:@"interfaceName"];
    [[AsiObjectManager sharedManager] setDelegate:self];
    [[AsiObjectManager sharedManager] requestData:urlParam];
}

- (void)loadData:(NSDictionary *)data
{
    //NSLog(@"%@", data); 
    NSArray *myArray = [data objectForKey:@"data"];   
    for (NSDictionary *dict in myArray) {
        NSArray *keys;
        int i, count;
        id key, value;
        keys = [dict allKeys];
        count = [keys count];
        for (i = 0; i < count; i++)
        {
            key = [keys objectAtIndex: i];
            value = [dict objectForKey: key];
            NSLog (@"Key: %@ for value: %@", key, value);
        }
    }
}

- (void) requestFailed:(NSError*)error{
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"医院医生排名";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
//    listData = [[NSArray alloc]initWithObjects: 
//                @"医生1",
//                @"医生2",
//                @"医生3",
//                @"医生4",
//                @"医生5",
//                @"医生6",
//                @"医生7",
//                @"医生8",
//                @"医生9",
//                @"医生10",                    
//                @"医生11",
//                @"医生12",
//                @"医生13",
//                @"医生14",
//                @"医生5",
//                @"医生6",
//                @"医生7",
//                @"医生8",
//                @"医生9",
//                @"医生10",
//                @"医生   5 ", nil];
//    //    [tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];	
////    [UIView beginAnimations:nil context:NULL];
////	[UIView setAnimationDuration:.3];
////	[tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
////	[UIView commitAnimations];
//    [tableView reloadData];
    
}

@end
