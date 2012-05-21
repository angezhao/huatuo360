//
//  DeptSelectVC.h
//  huatuo360
//
//  Created by Alpha Wong on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController2.h"
@protocol DeptSelectDelegate <NSObject> 
@required
- (void) selectDept:(NSString*)deptId deptName:(NSString*)deptName;
@end

@interface DeptSelectVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    id<DeptSelectDelegate> delegate;
}
- (void) setDelegate:(id)del;
@end
