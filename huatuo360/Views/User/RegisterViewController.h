//
//  RegisterViewController.h
//  huatuo360
//
//  Created by Alpha Wong on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"

@interface RegisterViewController : UIViewController<AsiObjectDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AlertViewDelegate>
{
    NSMutableArray *textfields;
    AsiObjectManager* manager;
    AlertViewManager* alertManager;
    Boolean willDisappear;
}

- (IBAction)registerButtonPressed:(id)sender;
@end
