//
//  UserInfoViewController.m
//  huatuo360
//
//  Created by Zhao Ange on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AlterPwdViewController.h"
#import "LoginViewController.h"
#import "Constants.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
        [self.navigationItem setHidesBackButton:true];
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
    [self.navigationItem setHidesBackButton:false];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"用户资料";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserInfoTableIdentifier = @"UserInfoTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             UserInfoTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: UserInfoTableIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 25)];
    label.textAlignment = UITextAlignmentRight;
    label.font = [UIFont boldSystemFontOfSize:16];
    //    label.font = [UIFont  fontWithName:@"黑体"  size:16];
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    
    UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, 200, 25)];
    labelText.textAlignment = UITextAlignmentLeft;
    labelText.font = [UIFont boldSystemFontOfSize:16];
    //    label.font = [UIFont  fontWithName:@"黑体"  size:16];
    labelText.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:labelText];
    
    NSUInteger row = [indexPath row];
    switch (row) {
        case 0:
            label.text = @"用户名：";
            labelText.text = userId;
            break;
            
        case 1:
            label.text = @"邮箱：";
            labelText.text = email;
            break;
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(IBAction)alterPwdButtonPressed:(id)sender{
    AlterPwdViewController* apvc = [[AlterPwdViewController alloc]initWithNibName:@"AlterPwdViewController" bundle:nil];
    [self.navigationController pushViewController:apvc animated:true];
}

-(IBAction)logoutButtonPressed:(id)sender{
    isLogin = false;
    LoginViewController* lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    userViewToShow = lvc;
    [self.navigationController setViewControllers:[[NSArray alloc]initWithObjects:lvc, nil] animated:TRUE];
}
@end
