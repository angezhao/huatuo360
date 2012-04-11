//
//  LoginViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
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
    [textField addTarget:self 
                  action:@selector(textFieldDone:) 
        forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [cell.contentView addSubview:textField];
    switch (row) {
        case 0:
            label.text = @"账号：";
            nameTextfield = textField;
            textField.returnKeyType = UIReturnKeyNext;
            break;
            
        case 1:
            label.text = @"密码：";
            pwTextfield = textField;
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

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    switch (textField.tag) {
//        case 0:
//            name = textField.text;
//            break;
//            
//        case 1:
//            password = textField.text;
//            break;
//    }
////    NSLog(textField.text);
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 0)
    {
        [pwTextfield becomeFirstResponder];
    }
    else {
        [pwTextfield resignFirstResponder];
    }
    return YES;
}

-(IBAction)loginButtonPressed:(id)sender
{
    userId = [[NSString alloc]initWithString:[nameTextfield text]];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:_login forKey:@"interfaceName"];
    [params setObject:[nameTextfield text] forKey:@"userid"];
    [params setObject:[pwTextfield text] forKey:@"password"];
    manager = [AsiObjectManager alloc];
    [manager setDelegate:self];
    [manager requestData:params];
}

-(IBAction)registerButtonPressed:(id)sender
{
    RegisterViewController* regViewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:regViewController animated:true];
}

- (void)loadData:(NSDictionary *)data
{
    //登陆成功
    isLogin = true;
    //要么显示个人中心页，要么显示评论页
}

- (void) requestFailed:(NSError*)error{
    //登陆失败
    isLogin = false;
}
@end
