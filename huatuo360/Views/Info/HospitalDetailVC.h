//
//  HospitalDetailVC.h
//  huatuo360
//
//  Created by Zhao Ange on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"

@interface HospitalDetailVC : UIViewController<AsiObjectDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSString* hospitalId;
    NSString* hospitalName;
    NSDictionary* hospitalData;
    NSArray* labels;
    NSArray* texts;
    NSArray* infoKeys;
    AsiObjectManager* manager;
    
    Boolean needRequest;
    UIBarButtonItem *btnComment;
    
    Boolean showAllInfo;
}

@property (nonatomic, strong)IBOutlet UITableView* detailView;
- (id)initWithHospId:(NSString*)hid hname:(NSString*)hname;
@end
