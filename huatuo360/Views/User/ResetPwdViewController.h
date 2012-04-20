//
//  ResetPwdViewController.h
//  huatuo360
//
//  Created by Zhao Ange on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"

@interface ResetPwdViewController : UIViewController<AsiObjectDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITextField *checkCodeTextfield;
    UITextField *newPwdTextfield;
    UITextField *newPwdTextfield1;
    UITextField *textFieldBeingEdited;
    AsiObjectManager* manager;
    AlertViewManager* alertManager;
}

@property (nonatomic, strong) NSString* resetPwdUserId;
-(IBAction)resetPwdButtonPressed:(id)sender;

@end
