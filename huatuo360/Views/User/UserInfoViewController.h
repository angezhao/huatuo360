//
//  UserInfoViewController.h
//  huatuo360
//
//  Created by Zhao Ange on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
}

-(IBAction)alterPwdButtonPressed:(id)sender;
-(IBAction)logoutButtonPressed:(id)sender;
@end
