//
//  LoginViewController.h
//  huatuo360
//
//  Created by Alpha Wong on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"

@interface LoginViewController : UIViewController<AsiObjectDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITextField *nameTextfield;
    UITextField *pwTextfield;
    UITextField *textFieldBeingEdited;
}

-(IBAction)loginButtonPressed:(id)sender;
-(IBAction)registerButtonPressed:(id)sender;
@end
