//
//  RegisterViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "Constants.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"华佗360";
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
    [textField addTarget:self 
                  action:@selector(textFieldDone:) 
        forControlEvents:UIControlEventEditingDidEndOnExit];
    [cell.contentView addSubview:textField];
    
    NSUInteger row = [indexPath row];
    textField.tag = row;
    switch (row) {
        case 0:
            label.text = @"账号：";
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

- (IBAction)registerButtonPressed:(id)sender
{
    userId = [[NSString alloc]initWithString:[[textfields objectAtIndex:0] text]];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:_regist forKey:@"interfaceName"];
    [params setObject:[[textfields objectAtIndex:0] text] forKey:@"userId"];
    [params setObject:[[textfields objectAtIndex:1] text] forKey:@"password"];
    [params setObject:[[textfields objectAtIndex:3] text] forKey:@"email"];
    [[AsiObjectManager sharedManager] setDelegate:self];
    [[AsiObjectManager sharedManager] requestData:params];
}

- (void)loadData:(NSDictionary *)data
{
    //注册成功
    isLogin = true;
}

- (void) requestFailed:(NSError*)error{
    //注册失败
    isLogin = false;
}
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [inputTexts replaceObjectAtIndex:textField.tag withObject:textField.text];
//}
@end
