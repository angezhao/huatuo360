//
//  RegisterViewController.h
//  huatuo360
//
//  Created by Alpha Wong on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSMutableArray *__unsafe_unretained textfields;
}

@property (unsafe_unretained) NSMutableArray *textfields;
- (IBAction)registerButtonPressed:(id)sender;
@end
