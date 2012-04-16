//
//  DoctorListVC.h
//  huatuo360
//
//  Created by Alpha Wong on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"
#import "DeptSelectVC.h"

@interface DoctorListVC : UIViewController<AsiObjectDelegate,UITableViewDelegate, UITableViewDataSource, DeptSelectDelegate>
{
    Boolean firstAppear;
    UIBarButtonItem *btnDetail;
    NSMutableArray* listData;
    int total;
    int page;
    AsiObjectManager* manager;
}

@property (nonatomic, strong)IBOutlet UITableView* listView;
@property (nonatomic, strong)IBOutlet UILabel* lbTitle;
@property (nonatomic, strong)IBOutlet UIButton* btnDept;
@property (nonatomic, strong)NSString* tableTitle;
- (NSString*)getTitleByIndex:(int)index;
- (NSString*)getIntroByIndex:(int)index;
@property (nonatomic, strong)NSMutableDictionary* params;
- (IBAction)showDeptList:(id)sender;
@end
