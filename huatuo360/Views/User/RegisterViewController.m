//
//  RegisterViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserInfoViewController.h"
#import "StringUtils.h"
#import "Constants.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"华佗360";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        [self.navigationItem setBackBarButtonItem:backItem];
        textfields = [NSMutableArray arrayWithCapacity:4];
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

- (void)viewWillDisappear:(BOOL)animated{
    willDisappear = true;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请输入注册信息";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 25)];
    label.textAlignment = UITextAlignmentRight;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 200, 25)];
    textField.clearsOnBeginEditing = NO;
    [textField setDelegate:self];
    //[textField addTarget:self 
    //              action:@selector(textFieldDone:) 
    //    forControlEvents:UIControlEventEditingDidEndOnExit];
    [cell.contentView addSubview:textField];
    
    NSUInteger row = [indexPath row];
    textField.tag = row;
    switch (row) {
        case 0:
            label.text = @"用户名：";
            textField.returnKeyType = UIReturnKeyNext;
            break;
            
        case 1:
            label.text = @"密码：";
            textField.returnKeyType = UIReturnKeyNext;
            textField.secureTextEntry = YES;
            break;
            
        case 2:
            label.text = @"确定密码：";
            textField.returnKeyType = UIReturnKeyNext;
            textField.secureTextEntry = YES;
            break;
            
        case 3:
            label.text = @"邮箱：";
            textField.returnKeyType = UIReturnKeyDone;
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
    }
    [textfields addObject:textField];
//    [textfields replaceObjectAtIndex:row withObject:textField];
    return cell;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag < 3) {
        UITextField *nextTextfield = [textfields objectAtIndex:textField.tag + 1];
        [nextTextfield becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //验证用户输入正确性
    if(!willDisappear && textField.tag == 0){
        NSString *msg = nil;
        NSString *name = [textField text];
        NSUInteger nameLength = [StringUtils getStringLength:name];
        if(nameLength < 3)
            msg = @"请输入用户名最少长度为3！";
        else {
            NSMutableDictionary* cparams = [NSMutableDictionary dictionaryWithCapacity:0];
            [cparams setObject:_checkUser forKey:@"interfaceName"];
            [cparams setObject:name forKey:@"userid"];
            manager = [AsiObjectManager alloc];
            NSDictionary *data = [manager syncRequestData:cparams];
            if (data == nil) {
                return NO;
            }
        }
        if(msg != nil){
            [self showAlter:msg];
            return NO;
        }
    } 
    return YES;
}

- (IBAction)registerButtonPressed:(id)sender
{
    //验证用户输入正确性
    NSString *msg = nil;
    NSString *name = [[textfields objectAtIndex:0] text];
    NSString *pwd = [[textfields objectAtIndex:1] text];
    NSString *pwd1 = [[textfields objectAtIndex:2] text];
    NSString *email = [[textfields objectAtIndex:3] text];
    
    NSUInteger nameLength = [StringUtils getStringLength:name];
    if(nameLength < 3 || nameLength > 15){
        msg = @"请输入用户名长度为3-15！";
    }else if(pwd == nil || [pwd length] < 6){
        msg = @"请输入至少6位密码！";
    }else if(pwd1 == nil || [pwd1 length] < 6){
        msg = @"请输入至少6位确认密码！";
    }else if(![pwd isEqualToString:pwd1]){
        msg = @"两次输入的密码不一致，请重输！";
    }else if(email == nil){
        msg = @"邮箱地址不能为空！";
    }
    if(msg != nil){
        [self showAlter:msg];
        return;
    }
    
    userId = [[NSString alloc]initWithString:name];
    NSMutableDictionary* rparams = [NSMutableDictionary dictionaryWithCapacity:0];
    [rparams setObject:_regist forKey:@"interfaceName"];
    [rparams setObject:userId forKey:@"userid"];
    [rparams setObject:pwd forKey:@"password"];
    [rparams setObject:email forKey:@"email"];
    manager = [AsiObjectManager alloc];
    [manager setDelegate:self];
    [manager requestData:rparams];
}

- (void)loadData:(NSDictionary *)data
{
    //注册成功
    isLogin = true;
    email = [data objectForKey:@"email"];
    UserInfoViewController* uivc = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    [self.navigationController setViewControllers:[[NSArray alloc]initWithObjects:uivc, nil] animated:TRUE];
    if(isComment){ //显示评论页
        isComment = false;
        [self.tabBarController setSelectedIndex:1];
    }
}

- (void) requestFailed:(NSError*)error{
    //注册失败
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
