//
//  DoctorDetailVC.h
//  huatuo360
//  医生详情
//  Created by Alpha Wong on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"

@interface DoctorDetailVC : UIViewController<AsiObjectDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSString* doctorId;
    NSString* doctorName;
    NSDictionary* doctorData;
    NSArray* labels;
    NSArray* texts;
    NSArray* infoKeys;
    
    NSArray* thesis;
    Boolean showAllThesis;
}
@property (nonatomic, strong)IBOutlet UITableView* detailView;

- (id)initWithDoctorId:(NSString*)did dname:(NSString*)dname;
@end
