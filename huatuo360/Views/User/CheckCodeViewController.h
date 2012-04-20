//
//  CheckCodeViewController.h
//  huatuo360
//
//  Created by Zhao Ange on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"

@interface CheckCodeViewController : UIViewController<AsiObjectDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITextField *nameTextfield;
    UITextField *emailTextfield;
    UITextField *textFieldBeingEdited;
    AsiObjectManager* manager;
    AlertViewManager* alertManager;
}

-(IBAction)getCheckCodeButtonPressed:(id)sender;


@end
