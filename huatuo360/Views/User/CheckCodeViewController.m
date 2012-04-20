//
//  CheckCodeViewController.m
//  huatuo360
//
//  Created by Zhao Ange on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CheckCodeViewController.h"
#import "ResetPwdViewController.h"
#include "Constants.h"

@interface CheckCodeViewController ()

@end

@implementation CheckCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    return @"获取验证码";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CheckCodeTableIdentifier = @"CheckCodeTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CheckCodeTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: CheckCodeTableIdentifier];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 25)];
    label.textAlignment = UITextAlignmentRight;
    label.font = [UIFont boldSystemFontOfSize:16];
    //    label.font = [UIFont  fontWithName:@"黑体"  size:16];
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    
    
    NSUInteger row = [indexPath row];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 25)];
    textField.tag = row;
    textField.clearsOnBeginEditing = NO;
    [textField setDelegate:self];
    //[textField addTarget:self 
    //              action:@selector(textFieldDone:) 
    //    forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [cell.contentView addSubview:textField];
    switch (row) {
        case 0:
            label.text = @"用户名：";
            nameTextfield = textField;
            textField.returnKeyType = UIReturnKeyNext;
            break;
            
        case 1:
            label.text = @"邮箱：";
            emailTextfield = textField;
            textField.returnKeyType = UIReturnKeyDone;
            break;
    }
    
    return cell;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textFieldBeingEdited = textField;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 0){
        [emailTextfield becomeFirstResponder];
    }
    else {
        [emailTextfield resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //验证用户输入正确性
    return YES;
}

-(IBAction)getCheckCodeButtonPressed:(id)sender{
    //验证用户输入正确性
    NSString *msg = nil;
    if([nameTextfield text] == nil || [[nameTextfield text] length] < 3){
        msg = @"请输入用户名最少长度为3！";
    }else if([emailTextfield text] == nil){
        msg = @"邮箱地址不能为空！";
    }
    if(msg != nil){
        [self showAlter:msg];
        return;
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:_resetPwd forKey:@"interfaceName"];
    [params setObject:@"mail" forKey:@"step"];
    [params setObject:[nameTextfield text] forKey:@"userid"];
    [params setObject:[emailTextfield text] forKey:@"email"];
    manager = [AsiObjectManager alloc];
    [manager setDelegate:self];
    [manager requestData:params];
}

- (void)loadData:(NSDictionary *)data
{
    //获取成功转入重置页面
    ResetPwdViewController* rpvc = [[ResetPwdViewController alloc]initWithNibName:@"ResetPwdViewController" bundle:nil];
    rpvc.resetPwdUserId = [nameTextfield text];
    [self.navigationController pushViewController:rpvc animated:true];
}

- (void) requestFailed:(NSError*)error{
    //获取验证码失败
    
}

-(void)showAlter:(NSString*)msg
{
    alertManager = [AlertViewManager alloc];
    [alertManager setDelegate:self];
    [alertManager showAlter:msg success:FALSE];
}

- (void)finishAlert:(BOOL)success
{
    
}
@end
