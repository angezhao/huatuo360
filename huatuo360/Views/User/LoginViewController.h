//
//  LoginViewController.h
//  huatuo360
//
//  Created by Alpha Wong on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"
#import "AlertViewManager.h"

@interface LoginViewController : UIViewController<AsiObjectDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AlertViewDelegate>
{
    UITextField *nameTextfield;
    UITextField *pwdTextfield;
    UITextField *textFieldBeingEdited;
    AsiObjectManager* manager;
    AlertViewManager* alertManager;
}

-(IBAction)loginButtonPressed:(id)sender;
-(IBAction)registerButtonPressed:(id)sender;
-(IBAction)forgetPswButtonPressed:(id)sender;
@end
