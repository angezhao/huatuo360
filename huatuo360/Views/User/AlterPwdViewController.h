//
//  AlterPwdViewController.h
//  huatuo360
//
//  Created by Zhao Ange on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"

@interface AlterPwdViewController : UIViewController<AsiObjectDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AlertViewDelegate>
{
    UITextField *oldPwdTextfield;
    UITextField *newPwdTextfield;
    UITextField *newPwdTextfield1;
    UITextField *textFieldBeingEdited;
    AsiObjectManager* manager;
    AlertViewManager* alertManager;
}

-(IBAction)alterPwdButtonPressed:(id)sender;

@end
