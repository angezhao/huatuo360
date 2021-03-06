//
//  LoginViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserInfoViewController.h"
#import "CheckCodeViewController.h"
#import "StringUtils.h"
#import "Constants.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    pwdTextfield.text = @"";
    nameTextfield.text = @"";
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
    return @"请输入帐号密码";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LoginTableIdentifier = @"LoginTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             LoginTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: LoginTableIdentifier];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 25)];
    label.textAlignment = UITextAlignmentRight;
    label.font = [UIFont boldSystemFontOfSize:16];
//    label.font = [UIFont  fontWithName:@"黑体"  size:16];
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    
    
    NSUInteger row = [indexPath row];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 200, 25)];
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
            label.text = @"密码：";
            pwdTextfield = textField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
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
    if(textField.tag == 0)
    {
        [pwdTextfield becomeFirstResponder];
    }
    else 
    {
        [pwdTextfield resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //验证用户输入正确性
    return YES;
}

-(IBAction)loginButtonPressed:(id)sender
{
    //验证用户输入正确性
    NSString *msg = nil;
    NSUInteger nameLength = [StringUtils getStringLength:[nameTextfield text]];
    if(nameLength < 3 || nameLength > 15){
        msg = @"请输入用户名长度为3-15！";
    }else if([pwdTextfield text] == nil || [[pwdTextfield text] length] < 6){
        msg = @"请输入密码最少长度为6！";
    }
    if(msg != nil){
        [self showAlter:msg];
        return;
    }
    userId = [[NSString alloc]initWithString:[nameTextfield text]];
    NSMutableDictionary* lparams = [NSMutableDictionary dictionaryWithCapacity:0];
    [lparams setObject:_login forKey:@"interfaceName"];
    [lparams setObject:userId forKey:@"userid"];
    [lparams setObject:[pwdTextfield text] forKey:@"password"];
    manager = [AsiObjectManager alloc];
    [manager setDelegate:self];
    [manager requestData:lparams];
}

-(IBAction)registerButtonPressed:(id)sender
{
    RegisterViewController* rvc = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:rvc animated:true];
}

-(IBAction)forgetPswButtonPressed:(id)sender
{
    CheckCodeViewController* ccvc = [[CheckCodeViewController alloc]initWithNibName:@"CheckCodeViewController" bundle:nil];
    [self.navigationController pushViewController:ccvc animated:true];
}

- (void)loadData:(NSDictionary *)data
{
    //登陆成功
    isLogin = true;
    email = [data objectForKey:@"email"];
    UserInfoViewController* uivc = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    [self.navigationController pushViewController:uivc animated:true];
    if(isComment){ //显示评论页
        isComment = false;
        [self.tabBarController setSelectedIndex:1];
    }
}

- (void) requestFailed:(NSError*)error{
    //登陆失败
    isLogin = false;
    userId = @"";
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
