//
//  AlterPwdViewController.m
//  huatuo360
//
//  Created by Zhao Ange on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AlterPwdViewController.h"
#import "Constants.h"

@interface AlterPwdViewController ()

@end

@implementation AlterPwdViewController

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
    return @"修改密码";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AlterPwdTableIdentifier = @"AlterPwdTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             AlterPwdTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: AlterPwdTableIdentifier];
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
            label.text = @"原密码：";
            oldPwdTextfield = textField;
            textField.returnKeyType = UIReturnKeyNext;
            textField.secureTextEntry = YES;
            break;
            
        case 1:
            label.text = @"新密码：";
            newPwdTextfield = textField;
            textField.returnKeyType = UIReturnKeyNext;
            textField.secureTextEntry = YES;
            break;
        case 2:
            label.text = @"确认密码：";
            newPwdTextfield1 = textField;
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
    if(textField.tag == 0){
        [newPwdTextfield becomeFirstResponder];
    }
    else if(textField.tag == 1){
        [newPwdTextfield1 becomeFirstResponder];
    }else {
        [newPwdTextfield1 resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //验证用户输入正确性
    return YES;
}

-(IBAction)alterPwdButtonPressed:(id)sender{
    //验证用户输入正确性，弹框提示
    NSString *msg = nil;
    if([oldPwdTextfield text] == nil || [[oldPwdTextfield text] length] < 6){
        msg = @"请输入至少6位原密码！";
    }else if([newPwdTextfield text] == nil || [[newPwdTextfield text] length] < 6){
        msg = @"请输入至少6位新密码！";
    }else if([newPwdTextfield1 text] == nil || [[newPwdTextfield1 text] length] < 6){
        msg = @"请输入至少6位确认密码！";
    }else if(![[newPwdTextfield text] isEqualToString:[newPwdTextfield1 text]]){
        msg = @"新密码与确认密码不一致，请重输！";
    }
    if(msg != nil){
        [self showAlter:msg];
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:_editPwd forKey:@"interfaceName"];
    [params setObject:userId forKey:@"userid"];
    [params setObject:[oldPwdTextfield text] forKey:@"password"];
    [params setObject:[newPwdTextfield text] forKey:@"newpassword"];
    manager = [AsiObjectManager alloc];
    [manager setDelegate:self];
    [manager requestData:params];
}

- (void)loadData:(NSDictionary *)data
{
    //修改成功
    //弹框提示成功后
    [self.navigationController popViewControllerAnimated:true];
}

- (void) requestFailed:(NSError*)error{
    //修改失败
    
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
